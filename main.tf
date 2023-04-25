#create private key for SSH access
resource "tls_private_key" "ins_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "mykey" {
  key_name = "ins_test_key"
  public_key = tls_private_key.ins_key.public_key_openssh
}

#Create Instance
resource "aws_instance" "test" {
    ami = "ami-05afd67c4a44cc983"
    instance_type = "t2.micro"
    key_name = aws_key_pair.mykey.key_name
    tags = {
      "Name" = "test"
    }
}

#download of Peivate key 
resource "local_file" "private_key" {
    content  = tls_private_key.ins_key.private_key_pem
   
    #Add location
    filename = "private_key.pem"
}

#print publicIP of Instance
output "outputip" { 
  value = aws_instance.test.public_ip   
}

output "ins_key" {
  value = tls_private_key.ins_key.private_key_pem
  sensitive = true
}
