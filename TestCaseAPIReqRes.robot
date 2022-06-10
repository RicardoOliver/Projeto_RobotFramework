*** Settings ***
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables ***
${base_url}                   https://reqres.in
${page}                       2

*** Test Cases ***
TC1: Obter o primeiro nome e e-mail de todos os usuários (GET) on page 2
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                             /api/users?page=${page}
  ${json_object}=             to json                           ${response.content}

  # Validação de dados
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${response_page}=           get value from json               ${json_object}                        $.page
  ${page}=                    convert to integer                ${page}
  should be equal             ${response_page[0]}               ${page}

  # Validação de dados multiplos
  ${first_names}=             get value from json         ${json_object}                       $..first_name
  ${first_name_count}=        get length                  ${first_names}
  ${first_name_count}=        convert to string           ${first_name_count}
  ${emails}=                  get value from json         ${json_object}                       $..email
  ${email_count}=             get length                  ${emails}
  ${email_count}=             convert to string           ${email_count}
  should be equal             ${first_name_count}         6
  should contain any          ${first_names}              Michael  Lindsay  Tobias  Byron  George  Rachel
  should be equal             ${email_count}              6
  should contain any          ${emails}                   michael.lawson@reqres.in  lindsay.ferguson@reqres.in tobias.funke@reqres.in  byron.fields@reqres.in  george.edwards@reqres.in rachel.howell@reqres.in
                                        


TC2: Obter um único usuário por id (GET)
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                                   /api/users/2
  ${json_object}=             to json                           ${response.content}

  # Validação de dados
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${email}=                   get value from json               ${json_object}                              data.email
  should be equal             ${email[0]}                       janet.weaver@reqres.in
  ${first_name}=              get value from json               ${json_object}                              data.first_name
  should be equal             ${first_name[0]}                  Janet
  ${last_name}=               get value from json               ${json_object}                              data.last_name
  should be equal             ${last_name[0]}                   Weaver
  ${avatar}=                  get value from json               ${json_object}                              data.avatar
  should be equal             ${avatar[0]}                      https://reqres.in/img/faces/2-image.jpg               

TC4: Criar o usuario (POST)
  create session              mysession                         ${base_url}
  ${body}=                    create dictionary                 name=Ricardo   job=QA Automation Engineer
  ${header}=                  create dictionary                 Content-Type=application/json
  ${response}=                post request                      mysession                                   /api/users      data=${body}                headers=${header}

  # Validação 
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    201
  ${res_body}=                convert to string                 ${response.content}
  should contain              ${res_body}                       Ricardo 
  should contain              ${res_body}                       QA Automation Engineer

TC5: Atualizar campo de trabalho para um usuário já existente (PUT)
  create session              mysession                         ${base_url}
  ${body}=                    create dictionary                 job=Software Developer
  ${header}=                  create dictionary                 Content-Type=application/json
  ${response}=                put request                       mysession                                 /api/users/3      data=${body}                headers=${header}

  # Validação 
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${res_body}=                convert to string                 ${response.content}
  should contain              ${res_body}                       Software Developer

TC6: Excluir um usuário por ID (DELETE)
  create session              mysession                         ${base_url}
  ${response}=                delete request                    mysession                                 /api/users/5

  # Validação
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    204