# whw

What happens when

## Requirement

- `docker-compose` - `v2.0.0`

- `docker` - `20.10.8`

## Steps

1. Start the containers by running `docker-compose up --build && docker-compose down`.

2. The last line should say
`docker-resolver-1  |  * Starting domain name service... named            [ OK ]`.

3. Open a new terminal window and run `docker exec -it docker-resolver-1 /bin/bash`.

4. Run the command `tcpdump udp`.

5. Open a new terminal window and run `docker exec -it docker-client-1 /bin/bash`.

6. Run the command `dig +short github.com`.

7. Go back to the terminal for `docker-resolver-1` and look at the output.
