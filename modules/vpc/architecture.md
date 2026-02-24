# Single AZ NAT Gateway Architecture.
# Network Layer is Done.
                         🌍 Internet
                              |
                              |
                     +-------------------+
                     |  Internet Gateway |
                     +-------------------+
                              |
                              |
                    +----------------------+
                    |  Public Route Table  |
                    |  0.0.0.0/0 → IGW     |
                    +----------------------+
                              |
          -----------------------------------------------
          |                                             |
+--------------------+                       +--------------------+
| Public Subnet A    |                       | Public Subnet B    |
| (AZ-a)             |                       | (AZ-b)             |
| map_public_ip=true |                       | map_public_ip=true |
+--------------------+                       +--------------------+
          |
          | (NAT placed in first public subnet only)
          |
     +------------------+
     |   NAT Gateway    |
     |   + Elastic IP   |
     +------------------+
          |
          |
    +----------------------+
    |  Private Route Table |
    |  0.0.0.0/0 → NAT     |
    +----------------------+
          |
  ------------------------------------------------
  |                                              |
+---------------------+                +---------------------+
| Private Subnet A    |                | Private Subnet B    |
| (AZ-a)              |                | (AZ-b)              |
+---------------------+                +---------------------+

# Public Subnet Traffic

```
EC2 -> Public Route Table -> IGW -> Internet
```

```
Private EC2 -> Route Table -> NAT Gateway -> Public Subnet -> IGW -> Internet
```