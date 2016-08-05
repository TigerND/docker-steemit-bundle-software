
FROM teego/steemit-bundle-system:latest
MAINTAINER Aleksandr Zykov <tiger@mano.email>

RUN figlet 'Building'

RUN ( \
        apt-get install -qy --no-install-recommends \
            git \
            build-essential \
    ) && \
    apt-get clean -qy
    
RUN ( \
        npm install --no-optional -g \
            babel-cli \
            sequelize-cli \
            node-gyp \
    )
    
ENV NODE_ENV development

ENV STEEMIT_REPOSITORY https://github.com/steemit/steemit.com
ENV STEEMIT_COMMIT e5f8b881fedb870245222d2acf6c9bd3c0a5d792
    
RUN figlet 'steemit.com '

RUN ( \
        cd /root; \
        git clone $STEEMIT_REPOSITORY steemit \
    )

RUN ( \
        cd /root/steemit; \
        ( \
            /usr/bin/test -n "$STEEMIT_COMMIT" && \
              git checkout $STEEMIT_COMMIT || \
              /bin/true \
        ) \
    )

ADD package.json.diff /root/steemit/

RUN  cd /root/steemit/; \
    ( \
        cat package.json.diff && \
        patch <package.json.diff \
    )
    
RUN cd /root/steemit/; \
    ( \
        NODE_ENV=development npm install --no-optional --no-shrinkwrap \
    )

CMD ["/bin/bash"]

RUN figlet 'Ready!'
