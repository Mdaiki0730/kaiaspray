locals {
  ansible_inventory = templatefile(
    "${path.module}/templates/inventory.tftpl",
    {
      ansible_ssh_private_key_file = try(module.keypair.ssh_private_key_path, "<change-me>")
      cn                           = try(module.layer1.cn, [])
      pn                           = try(module.layer1.pn, [])
      en                           = try(module.layer1.en, [])
      scn                          = try(module.scn, [])
      monitor                      = try(module.layer1.monitor, {})
    }
  )
  ansible_vars_all = templatefile(
    "${path.module}/templates/groupvarsall.tftpl",
    {
      kaia_version = var.deploy_options.kaia_version
      kaia_num_cn = var.cn_options.count
      kaia_num_pn = var.pn_options.count
      kaia_num_en = var.en_options.count
      kaia_num_scn = var.scn_options.count
      kaia_network_id = var.deploy_options.kaia_network_id
      kaia_chain_id = var.deploy_options.kaia_chain_id
      kaia_service_network_id = var.deploy_options.kaia_service_network_id
      kaia_service_chain_id = var.deploy_options.kaia_service_chain_id
    }
  )
}

resource "local_file" "this" {
  content  = local.ansible_inventory
  filename = format("%s/../../../inventory/%s/inventory.ini", path.module, basename(abspath(path.module)))
}

resource "local_file" "ansible_group_vars_all" {
  content  = local.ansible_vars_all
  filename = format("%s/../../../inventory/%s/group_vars/all/all.yml", path.module, basename(abspath(path.module)))
}
