# movebox
Docker with inotify watched inbox, which transfered completely written files to outbox.

## docker-compose.yml

        services:
          movebox:
            #build: .
            image: martinpichlo/movebox
            restart: unless-stopped
            environment:
              INBOX: "/mnt/inbox"
              OUTBOX: "/mnt/outbox"
            volumes:
              - ./inbox:/mnt/inbox
              - ../paperless-ng/consume:/mnt/outbox
