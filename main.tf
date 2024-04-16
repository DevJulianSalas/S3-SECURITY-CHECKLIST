//Get Block public access information
data "aws_s3_account_public_access_block" "checkBlockPublicAccess"{
    account_id = var.account_id
}
//

