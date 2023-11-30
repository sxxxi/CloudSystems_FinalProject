#!/bin/sh

remote_host=$1
local_pubkey=$2

sftp ec2-user@$remote_host:~/.ssh <<< $"put $local_pubkey"

echo "-----BEGIN RSA PRIVATE KEY-----
      MIIEowIBAAKCAQEAnVtw5p4r2j2m70EbGu8ab0H9cdiUenJ/YNiLfT98Nvm1/VO/
      A2DChCnNUtXumeVvhAiMlIDobYSenkY0CiljDythrcftJW04ecbwDGQ38CynkDVu
      3D+7FIUWBrK/5cV+vnMAOOaJm+8b/dinEVfqtstnoelqQaXGEzWAVaCmyiDvvPfo
      jmRooZC3vn3mwiQU/0ECZ0oLQF8fw1BTfydyYjFyAxPGeJfkq1KY7vtyur9N+9eG
      b3OlMEdfDGTjM1ct+nc+SYfX624DWpzGv+URMSuT9s698qn2l0P0BSGBi1jQCG+u
      DvBbwIeBFkf9LVGg2iKSQcvd5O2GRgv8cEmrSwIDAQABAoIBAAvm57I50n1OXnsI
      RKGT5j72EdJznD9qu6G6n0pY6+9IkfBYTkFWJ0BR3Rrf3Y08YmPtNZzh5zKpbknw
      a209ViXGlTvMvG4xRa1IU83MIsMCzaXFtN3p4B+cNV9KU+NwPbbwAdtL7Kqjuk1H
      /tL8AF/VIMCJZCUVAddgG5Xecd8l4etmDlmK4zYXfP8IsrmR5MV5D4ZNb6u1XWdC
      pfiCTNPBL36nJDrwZacWuR9J12CWti/XBBKUrLEYlOnIseDkSfzPtZeBJQqVwrKo
      UaLqAqxpqge6IsVBY5Hb8ERhuM8UkMMuYVCL5ENaX9fGWgKD8kzISDMGT332RyDR
      ji8CQCECgYEA6H1sEoHFHKkTd+D+H1knxedCX5CnHMHpNW02xDMwLU28gLUIBN38
      CBsQuLI5sUst64ePu39QJ5joVAB46ZZaDUJL/g67pz+v1QhOq1C2w7r/SGyivpQH
      ttByoCo070oIcShfE1LjWUSIaVZVqkDUQUvrokEr0hQlKyo6+B+opBsCgYEArUUF
      kwkzlG2vcWqoieNZqffurZ0A7OKzNhDk3uyDd2DjtNaCLqwVc/WDF3G+4XwPqoVd
      OsS4DoQ/sdaX96wPaoOB8Mo6HMAMnSDUQ3JMOdCi2N6Z+U6dqW1/q/GLeHF6hTVS
      bNOkO8v11p5rY49gqy0yZM4+7bFlF1i4pAVpqJECgYEAxDh/S0ttotfsz4P811Z3
      JCggM+oxsSrUerw3ufZ+Fe6DR5oDL6BvxCObxFbgLIwIML7Uh+pXK2R5ydQwOO4m
      CQTIgJ/Mr8cnz0RYqWzRJHeiWG0gGntz208pP5b/4Gp6n470V6ngqooWG9m7KZvX
      yVibgvFAW+mWyUy2Qo7t1bsCgYA8hS5ERGOCxakRGWsS9pk7+ACjHYLUOv7TtKTs
      hHoK+YmvgXlpKew4W5nVV4KPqdCjBAAjZdDQKTtCN61O8gdUceiyHUCdCCufunbJ
      tCOR0iD/VQk8/kutgTSl7zGC+UgNPSm0H1xvEnek5iKmXM8sGxZOBYgPZ/XiaLfd
      epKEMQKBgALcsdtQSBGE3UKr2NHROMEd8cCiD6LjWdSYDKXW/Wezrw2Sz2WpX6tr
      LIsn3OiB5RNUIhlCSr2Li6di4GcN3IkYqkkvf63Y6kZKu274AeblCZC8n8vnC9RX
      +oGEojVtLFTN5Bu2ACzMeXV2nlt+fY87M8L8ir+p0Z1G7h16YgGd
      -----END RSA PRIVATE KEY-----" > key.pem

sudo chmod 400 key.pem