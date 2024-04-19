FROM perl:5.26
LABEL maintainer="Alexander Orlovsky <nordicdyno@gmail.com>"
# add cpanm dependencies
RUN apt-get update && apt-get upgrade -y
RUN cpanm --self-upgrade
RUN cpanm CHI
RUN cpanm Config::IniFiles
RUN cpanm --verbose --notest Term::ReadKey && rm -rf ~/.cpanm
RUN cpanm --verbose App::cpm && rm -rf ~/.cpanm
RUN cpanm --verbose Carton::Snapshot && rm -rf ~/.cpanm
# install dependencies and code
WORKDIR /app
ADD . /app
COPY cpanfile /app/cpanfile
COPY cpanfile.snapshot /app/cpanfile.snapshot
RUN cpanm Data::MessagePack
RUN cpanm Mouse
RUN cpanm Net::SSLeay
RUN cpanm Net::Server
RUN cpanm Test::SharedFork
RUN cpm install --notest --verbose --show-build-log-on-failure -g && rm -rf ~/.cpanm

CMD command starman --port 9000
