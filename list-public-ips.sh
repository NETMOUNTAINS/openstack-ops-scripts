#!/bin/bash
echo "IP Address | Resource Type | Name"
# Temporary file for storing results
tmpfile=$(mktemp)

# 1. Server IPs
echo "Collecting Server IPs..."
openstack --insecure server list --long --all-projects -f value -c Name -c Networks | while read -r name networks; do
    echo "$networks" | tr ',' '\n' | while read -r entry; do
        ip=$(echo "$entry" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -n "$ip" ]]; then
            # Filter private IPs and Link-Local addresses
            if ! echo "$ip" | grep -qE '^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^169\.254\.'; then
                echo "$ip | Server | $name" >> "$tmpfile"
            fi
        fi
    done
done

# 2. Floating IPs
echo "Collecting Floating IPs..."
openstack --insecure floating ip list --long -f value -c "Floating IP Address" -c "Fixed IP Address" -c "Port" | while read -r float_ip fixed_ip port; do
    if [[ -n "$float_ip" ]]; then
        # Filter private IPs and Link-Local addresses
        if ! echo "$float_ip" | grep -qE '^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^169\.254\.'; then
            # Try to determine the associated server name
            if [[ -n "$port" && "$port" != "None" ]]; then
                port_details=$(openstack --insecure port show "$port" -f value -c device_id -c name 2>/dev/null)
                device_id=$(echo "$port_details" | head -1)
                port_name=$(echo "$port_details" | tail -1)
                
                if [[ -n "$device_id" && "$device_id" != "None" ]]; then
                    server_name=$(openstack --insecure server show "$device_id" -f value -c name 2>/dev/null || echo "Unknown")
                    echo "$float_ip | Floating IP | $server_name (Port: $port_name)" >> "$tmpfile"
                else
                    echo "$float_ip | Floating IP | Not assigned (Port: $port_name)" >> "$tmpfile"
                fi
            else
                echo "$float_ip | Floating IP | Not assigned" >> "$tmpfile"
            fi
        fi
    fi
done

# 3. Router IPs
echo "Collecting Router IPs..."
openstack --insecure router list --long -f value -c ID -c Name | while read -r router_id router_name; do
    # Query router ports with external IPs
    openstack --insecure port list --router "$router_id" -f value -c "Fixed IP Addresses" | while read -r ip_info; do
        # Extract IP addresses (format may vary)
        ip=$(echo "$ip_info" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -n "$ip" ]]; then
            # Filter private IPs and Link-Local addresses
            if ! echo "$ip" | grep -qE '^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^169\.254\.'; then
                echo "$ip | Router | $router_name" >> "$tmpfile"
            fi
        fi
    done
    
    # Alternative: Query router gateway info
    gateway_info=$(openstack --insecure router show "$router_id" -f value -c external_gateway_info 2>/dev/null)
    if [[ -n "$gateway_info" && "$gateway_info" != "None" ]]; then
        gateway_ip=$(echo "$gateway_info" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -n "$gateway_ip" ]]; then
            # Filter private IPs and Link-Local addresses
            if ! echo "$gateway_ip" | grep -qE '^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^169\.254\.'; then
                echo "$gateway_ip | Router Gateway | $router_name" >> "$tmpfile"
            fi
        fi
    fi
done

echo "Sorting results..."
# Sort by IP address
sort -t. -k1,1n -k2,2n -k3,3n -k4,4n "$tmpfile"

# Clean up
rm -f "$tmpfile"
