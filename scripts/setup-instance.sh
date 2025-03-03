              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
        
              sudo apt-get install -y nginx
              echo "<h1> Ola, Mundo VEx! </h1>" | sudo tee /var/www/html/index.html
              sudo systemctl restart nginx