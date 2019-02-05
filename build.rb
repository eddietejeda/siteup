require 'csv'
require 'json'

json_row = []

File.open("status.json", "w") {}

File.open("status.json","a") do |f|

  CSV.foreach("https.csv", headers: true) do |row|
    status = `curl -LI https://#{row[0]} -o /dev/null -w '%{http_code}\n' -s`

    certificate = `echo | openssl s_client -showcerts -servername #{row[0]}  -connect #{row[0]}:443 2>/dev/null | openssl x509 -inform pem -noout -enddate 2>/dev/null`
  
    json_row << {
      domain: row[0], 
      status:status.strip, 
      certificate_expires: certificate.strip.split("=").last ? DateTime.parse(certificate.strip.split("=").last) : '',
      last_checked: DateTime.now
    }
  
    puts JSON.pretty_generate(json_row)
    f.puts(JSON.pretty_generate(json_row))
  
  end


end