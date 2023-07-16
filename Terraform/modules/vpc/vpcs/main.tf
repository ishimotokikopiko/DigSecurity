variable "name" {type=string}
variable "cidr" {type=string}

variable "one_nat" {default=false}

variable "public_zones" {type=list(string)}
variable "public_base" {default=0}
variable "public_bits" {default=8}

variable "tags" {type=map(string)}

variable "vpc_tags"{
    type=map(string)
    default={}
}

variable "public_tags"{
    type=map(string)
    default={}
}

module "vpc" {
    source="../public/"

    name=var.name
    cidr=var.cidr

    public_zones=var.public_zones
    public_base=var.public_base
    public_bits=var.public_bits
    public_tags=var.public_tags

    vpc_tags=var.vpc_tags
    tags=var.tags
}

resource "aws_route_table" "private" {
    count=var.one_nat ? 1:length(var.public_zones)

    vpc_id=module.vpc.id
    tags=merge(var.tags,{
        Name=var.one_nat ? "${var.name}-prv-rt:"${var.name}-prv-rt-${count.index}"
        Tier="Private"
    })
}

resource "aws_eip" "natgw" {
    count=var.one_nat ? 1:length(var.public_zones)

    vpc=true
    tags=merge(var.tags,{
        Name=var.one_nat ? "${var.name}-natgw-eip-${count.index}"
        Tier="Private"
    })
}

resource "aws_nat_gateway" "natgw" {
    count=var.one_nat ? 1:length(var.public_zones)

    subnet_id=module.vpc.public_subnets.ids[count.index]
    allocation_id=aws_eip.natgw[count.index].id

    tags=merge(var.tags,{
        Name=var.one_nat ? "${var.name}-prv-natgw-${count.index}"
        Tier="Private"
    })
}

# Route via nat-gw.
resource "aws_route" private-natgw" {
    count=var.one_nat ? 1:length(var.public_zones)

    route_table_id=aws_route_table.private[count.index].id
    destination_cidr_block="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.natgw[count.index].id
}

#Output variables.
Output "id" {value=module.vpc.id}
Output "name" {value=module.vpc.name}

Output "rt_default" {value=module.vpc.rt_default.id}
Output "rt_public" {value=module.vpc.rt_public}
Output "rt_private" {value=aws_route_table.private.*.id}

Output "public_subnets" {value=module.vpc.public_subnets}
Output "natgw_ip" {value=aws_eip.natgw.*.public_ip}