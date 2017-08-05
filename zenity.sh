#!/bin/bash
zenity --list \
        --checklist \
        --title="To do list" \
        --width=500 \
        --height=500 \
        --separator=\\n \
        --column="Check" --column="Content" \
