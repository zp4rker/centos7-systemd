FROM centos7-systemd:py27

# Install starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
