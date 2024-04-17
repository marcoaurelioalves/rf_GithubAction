*** Settings ***
Library    Browser
Library    FakerLibrary
Library    DateTime



*** Variables ***
${BROWSER}                 chromium
${HEADLESS}                ${false}
${SITE_SERVE_REST}         https://front.serverest.dev/


*** Keywords ***
Abrir o navegador
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}    

    #${TRACE_NAME}      FakerLibrary.Uuid 4
    #${NOW}             Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context        viewport={'width': 1200, 'height': 800}   
    #...                tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    #...                recordVideo={'dir':'${OUTPUT_DIR}/evidencies/videos/${NOW}'}

Ir para o site Serve Rest Front
    New Page        url=${SITE_SERVE_REST}
    ${title}        Get Title    ==   Front - ServeRest
    Sleep           2s

Preencher os dados do novo usuário e cadastrar
    #Record Selector
    Click               css=.btn-link
    # Click             text="Cadastre-se"
    # Click             css=a[data-testid='cadastrar']
    ${EMAIL}            FakerLibrary.Email
    Set Test Variable   ${EMAIL}
    Fill Text           css=input[data-testid='nome']        Marco Aurelio
    Fill Text           css=input[data-testid='email']       ${EMAIL}
    Fill Text           css=input[data-testid='password']    123456
    Check Checkbox      css=input[data-testid='checkbox'] 
    Click               css=button[data-testid='cadastrar'] 
    Sleep               5s

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1     visible
    Get Text    h1  ==  Bem Vindo Marco Aurelio


Cadastrar novo usuário
    Abrir o navegador    
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar

Acessar a Lista de usuários    
    Click        css=a[data-testid='listarUsuarios']
    #Click         css=.btn.text-light

Conferir que o usuário aparece na listagem
    ${elemento}        Get Table Cell Element        css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}    Get Text    ${elemento}       ==  Marco Aurelio
    Highlight Elements             ${elemento}
    Take Screenshot                fullPage=${true}