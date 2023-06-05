#!ruby
#
# script with various mailcow API utilities
#
# Axel Roest, 2023

require 'json'
require 'net/http'

load 'secrets.rb'
load 'aliases.rb'

def getMailboxes(domain)
	if domain == "" then
		domain = "demo.mailcow.email"
	end
		
	path = "/api/v1/get/mailbox/all/#{domain}"
	url = $BaseURL + path

	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Get.new(path)
	request['X-API-Key'] = $READKEY
	
	headers = 
	{
		'X-API-Key' => $READKEY
	}

	response = net.request(request)
	puts response.body if response.is_a?(Net::HTTPSuccess)
end

def getAliases(id)
	if id == "" then
		id = "all"
	end
		
	path = "/api/v1/get/alias/#{id}"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Get.new(path)
	request['X-API-Key'] = $READKEY

	response = net.request(request)
	puts response.body  if response.is_a?(Net::HTTPSuccess)
end

def getDomainAliases(mailbox)
	if mailbox == "" then
		mailbox = "all"
	end
		
	path = "/api/v1/get/alias/#{mailbox}"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Get.new(path)
	request['X-API-Key'] = $READKEY

	response = net.request(request)
	puts response.body  if response.is_a?(Net::HTTPSuccess)
end

def addAlias(aliasEmail, mailbox)
	if !aliasEmail || !mailbox then
		puts "Error: aliasEmail or mailbox cannot be nil"
	end

	path = "/api/v1/add/alias"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Post.new(path)
	request['X-API-Key'] = $EDITKEY
	
	body =	{
	  "active": "1",
	  "address": aliasEmail,
	  "goto": mailbox
	}.to_json
#	jsonBody = JSON.generate(body)
	request.body = body
	request.content_type = 'application/json'

	response = net.request(request)
	puts response.body
end

def getBlacklist(domain)
	
	path = "/api/v1/get/policy_bl_domain/#{domain}"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Get.new(path)
	request['X-API-Key'] = $READKEY

	response = net.request(request)
	puts response.body  if response.is_a?(Net::HTTPSuccess)

end

def addBlacklist(domain, email)
	if !domain || !email then
		puts "Error: domain or email cannot be nil"
	end

	path = "/api/v1/add/domain-policy"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Post.new(path)
	request['X-API-Key'] = $EDITKEY
	
	body =	{
		"domain": domain,
		"object_from": email,
		"object_list": "bl"
	}.to_json
	
	request.body = body
	request.content_type = 'application/json'

	response = net.request(request)
	puts response.body


end

def addBlacklistList(domain, emails)
	emails.each do |email| 
		addBlacklist(domain,email) 
	end
end

def addAliasesFromHash(aliasHash) 
	aliasHash.each do |address, mailboxes|
		puts "#{address} -> #{mailboxes}"
		addAlias(address, mailboxes)
		sleep 0.2
	end

end

def getDKIM(domain)
		
	path = "/api/v1/get/dkim/#{domain}"
	url = $BaseURL + path
	puts path
	
	net = Net::HTTP.new($BaseURL, 443)
	net.use_ssl = true
	
	request = Net::HTTP::Get.new(path)
	request['X-API-Key'] = $READKEY
	request['accept'] = "application/json"

	response = net.request(request)
# 	puts response.body  if response.is_a?(Net::HTTPSuccess)
	record = JSON.parse(response.body)
	puts record['dkim_txt']

end

getMailboxes(nil)
# getDomainAliases("all")
# addAlias("pietjepuk@example.com", "you@example.com")

# this function adds the hash with aliases (from aliases.rb)
# addAliasesFromHash($aliases)
# getBlacklist("example.com")
# addBlacklist("example.com", "virusalert@example.com")
# addBlacklistList("example.com", $emails)
# getDKIM("example.com")
