FROM centos/systemd

MAINTAINER Melih Savdert <melihsavdert@gmail.com>

# Update the operating system
RUN yum makecache fast \
 && yum -y install epel-release \
 && yum -y update

# Install necessary packages
RUN ["yum", "-y", "install", \
       "vim", \
       "which", \
       "sudo", \
       "openssh", \
       "openssh-server", \
       "openssh-clients", \
       "openssl-libs", \
       "net-tools", \
       "python-pip"]

# Clean the yum cache
RUN ["yum", "clean", "all"]

# Enable sshd service
RUN systemctl enable sshd

# Add ansible infrastructure owner
RUN ["groupadd", "--force", "ansible"]
RUN useradd --create-home -g ansible ansible

# Give ansible user passwords
RUN echo "ansible:ansible" | chpasswd

RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

# Set the environment variables
ENV HOME /root

# Working directory
WORKDIR /root

CMD ["/usr/sbin/init"]

