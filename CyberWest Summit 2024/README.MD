# CyberWest Summit 2024 | Emu Exploit
https://www.cyberwestsummit.com.au/program#:~:text=A%20live%20hacking%20demonstration%20involving%20common%20types%20of%20attack
<details open>
<summary>Description</summary>
<br>
Hackers don't just wear hoodies! It's time we moved beyond the ideas of scary super-hackers and acknowledge that the skills and knowledge needed to compromise computer systems are more common than many think. In this session attendees will see real demonstrations of common attacks giving them a more grounded idea of what 'hacking' really means, from Australia’s top-ranked competitive hacking team, Emu Exploit. As organisations put increasing resources into protecting themselves from the commonly sensationalised threat of cyber-attack, it is vital that decision-makers are given opportunities to learn from hackers what that label really means.
</details>

#### [Slides](/slides_cws24.pdf) | [Lab](/docker-compose.yml)

### Demo
- This lab uses Docker and docker-compose
- Networking is managed in docker, however exact configuration may differ 

Up/Down:
```
docker-compose up -d --build 
docker-compose down 
```

Attacker Box: `hacktheplanet`
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