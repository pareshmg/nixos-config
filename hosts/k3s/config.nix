{
  # The Virtual IP that will be shared across nodes
  virtualIp = "10.28.10.110"; 
  # List of your control plane node physical IPs
  serverIps = [
    "10.28.16.20"
    "10.28.16.21"
    "10.28.16.22"
  ];

  workerIps = [
    "10.28.15.23"
  ];
  
}
