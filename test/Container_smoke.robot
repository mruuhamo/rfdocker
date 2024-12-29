*** Settings ***

Library    Browser
Library    OperatingSystem

*** Variables ***
${URL}                https://google.fi
${Search_field}       div > textarea    #textarea[title="Search"]
${input_text}         Savukoe
${Response_text}      Savukoe tarkoittaa erilaisia järjestelmien kokeita, jotka yleensä määrittävät, ovatko järjestelmät valmiita kovempiin kokeisiin.
${SCREEN_HEIGHT}      1080
${SCREEN_WIDTH}       1920

*** Test Cases ***

Search google with Browserlibrary
    [Documentation]
    ...    Running Smoke test for Browserlibrary, using Chrome
    Open browser to google Browserlibrary
    Basic search in google Browserlibrary


*** Keywords ***

Open browser to google Browserlibrary
    [Documentation]
    ...        Open new chromium instance
    ...        Then go to google page, and confirm GDPR popup

    New Browser    browser=chromium    headless=true    
    New Page    ${URL}
    Set Viewport Size    ${SCREEN_WIDTH}    ${SCREEN_HEIGHT}
    
    # Confirm GDPR popup
    Click    xpath=//*[@id="L2AGLb"]/div

Basic search in google Browserlibrary
    [Documentation]
    ...    Search for Savukoe (Smoke test) in google

    Fill Text     ${Search_field}    ${input_text}    force=True
    Press Keys    ${Search_field}    Enter
    Get Text      xpath=//*[@id="rso"]/div[1]/div    contains    ${Response_text}
    Take Screenshot