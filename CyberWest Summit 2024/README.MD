# CyberWest Summit 2024 | Emu Exploit
https://www.cyberwestsummit.com.au/program#:~:text=A%20live%20hacking%20demonstration%20involving%20common%20types%20of%20attack

#### [Slides]()
#### [Lab](#)

### Live Demo Lab
- This lab uses Docker and docker-compose
- Networking is managed in docker, however exact configuration may differ 

Up/Down:
```
docker-compose up -d --build 
docker-compose down 
```

Attacker: `hacktheplanet`
```
ssh -p 2222 root@172.69.0.20
```

## SOME MANUAL SETUP REQUIRED

Adding Hostnames:
```
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "172.69.0.4 demo demo.lab securesales securesales.com" ; Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "172.69.0.20 attacker attacker.evil attacker.com" 

echo -ne "172.69.0.4 demo demo.lab securesales securesales.com\n172.69.0.20 attacker attacker.evil attacker.com" | sudo tee -a /etc/hosts
```

OpenCATS Configuration:

Forward the Service:
```
ssh -L 8080:localhost:8080 -i lab/src/ssh/root-id_rsa root@172.69.0.4
```
Open `http://ip:8080/installwizard.php?hijack` in a browser, wait for installation to complete.

# GLHF!