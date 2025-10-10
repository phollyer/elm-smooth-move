module Common.Styles exposing 
    ( responsiveCSS
    , horizontalCSS
    , diagonalCSS
    , containerCSS
    , horizontalContainerCSS
    )


-- RESPONSIVE CSS


responsiveCSS : String
responsiveCSS =
    """
    /* Mobile-first responsive design */
    @media (max-width: 768px) {
        .responsive-layout {
            padding: 20px 16px !important;
        }
        
        .responsive-container {
            gap: 20px !important;
        }
        
        .responsive-header {
            font-size: 24px !important;
            text-align: center;
            padding: 0 16px;
        }
        
        .responsive-tech-info {
            padding: 16px 20px !important;
            margin: 0 16px;
        }
        
        .responsive-buttons {
            gap: 16px !important;
            padding: 0 16px;
        }
        
        .responsive-buttons button {
            width: 100%;
            min-height: 44px;
            padding: 12px 20px !important;
        }
        
        .responsive-paragraph {
            padding: 20px 16px !important;
            margin: 0 16px;
        }
        
        .responsive-paragraph h1,
        .responsive-paragraph h2,
        .responsive-paragraph h3 {
            font-size: 20px !important;
        }
    }
    
    @media (max-width: 480px) {
        .responsive-layout {
            padding: 16px 12px !important;
        }
        
        .responsive-header {
            font-size: 20px !important;
        }
        
        .responsive-tech-info {
            padding: 12px 16px !important;
            margin: 0 12px;
        }
        
        .responsive-paragraph {
            padding: 16px 12px !important;
            margin: 0 12px;
        }
        
        .responsive-buttons {
            padding: 0 12px;
        }
    }
    """


-- HORIZONTAL LAYOUT CSS


horizontalCSS : String
horizontalCSS =
    """
    body {
        overflow-x: auto !important;
        overflow-y: auto !important;
    }

    .horizontal-layout {
        min-height: 100vh;
        height: auto;
        width: 500vw;
        padding: 20px 40px !important;
    }

    .horizontal-content-row {
        min-width: 500vw;
    }

    body::-webkit-scrollbar:horizontal {
        height: 12px;
    }

    body::-webkit-scrollbar-track:horizontal {
        background: #F7FAFC;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb:horizontal {
        background: #CBD5E0;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb:horizontal:hover {
        background: #A0AEC0;
    }

    @media (max-width: 768px) {
        .horizontal-layout {
            width: 300vw;
            padding: 20px 16px !important;
        }
        
        .horizontal-content-row {
            min-width: 300vw;
        }
    }

    @media (max-width: 480px) {
        .horizontal-layout {
            width: 200vw;
            padding: 8px 4px !important;
        }
        
        .horizontal-content-row {
            min-width: 200vw;
        }
    }
    """


-- DIAGONAL LAYOUT CSS


diagonalCSS : String
diagonalCSS =
    """
    body {
        overflow-x: auto !important;
        overflow-y: auto !important;
    }

    .diagonal-layout {
        min-height: 300vh;
        height: auto;
        width: 300vw;
        padding: 20px 40px !important;
    }

    .diagonal-content-grid {
        min-width: 300vw;
        min-height: 300vh;
    }

    body::-webkit-scrollbar {
        width: 12px;
        height: 12px;
    }

    body::-webkit-scrollbar-track {
        background: #F7FAFC;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb {
        background: #CBD5E0;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb:hover {
        background: #A0AEC0;
    }

    @media (max-width: 768px) {
        .diagonal-layout {
            min-height: 250vh;
            width: 250vw;
            padding: 20px 16px !important;
        }
        
        .diagonal-content-grid {
            min-width: 250vw;
            min-height: 250vh;
        }
    }

    @media (max-width: 480px) {
        .diagonal-layout {
            min-height: 200vh;
            width: 200vw;
            padding: 12px !important;
        }
        
        .diagonal-content-grid {
            min-width: 200vw;
            min-height: 200vh;
        }
    }
    """


-- CONTAINER LAYOUT CSS


containerCSS : String
containerCSS =
    """
    .container-layout {
        min-height: 100vh;
        padding: 20px;
        box-sizing: border-box;
    }
    
    .scroll-container-wrapper {
        max-width: 1200px;
        width: 100%;
        margin: 0 auto;
    }

    /* Scrollbar styles for the scroll container */
    #scroll-container {
        overflow-y: auto !important;
        scrollbar-width: thin;
        scrollbar-color: #CBD5E0 #F7FAFC;
    }

    #scroll-container::-webkit-scrollbar {
        width: 12px;
    }

    #scroll-container::-webkit-scrollbar-track {
        background: #F7FAFC;
        border-radius: 6px;
        margin: 6px;
    }

    #scroll-container::-webkit-scrollbar-thumb {
        background: #CBD5E0;
        border-radius: 6px;
    }

    #scroll-container::-webkit-scrollbar-thumb:hover {
        background: #A0AEC0;
    }

    /* Responsive content block styling */
    .responsive-content-block {
        padding: 20px !important;
    }

    .responsive-content-title {
        font-size: inherit !important;
    }

    .responsive-content-description {
        font-size: inherit !important;
        line-height: 1.5 !important;
    }

    .responsive-bullet-list {
        font-size: inherit !important;
    }

    .responsive-bullet-point {
        font-size: inherit !important;
        line-height: 1.4 !important;
        margin-bottom: 6px !important;
    }

    @media (max-width: 768px) {
        .container-layout {
            padding: 16px;
        }
        
        .responsive-content-block {
            padding: 16px !important;
        }
        
        .responsive-content-title {
            font-size: 18px !important;
        }
        
        .responsive-content-description {
            font-size: 14px !important;
        }
        
        .responsive-bullet-list {
            font-size: 14px !important;
        }
        
        .responsive-bullet-point {
            font-size: 14px !important;
            margin-bottom: 8px !important;
        }
    }

    @media (max-width: 480px) {
        .container-layout {
            padding: 12px;
        }
        
        .responsive-content-block {
            padding: 12px !important;
        }
        
        .responsive-content-title {
            font-size: 16px !important;
        }
        
        .responsive-content-description {
            font-size: 13px !important;
        }
        
        .responsive-bullet-list {
            font-size: 13px !important;
        }
        
        .responsive-bullet-point {
            font-size: 13px !important;
            margin-bottom: 8px !important;
        }
    }
    """


-- HORIZONTAL CONTAINER LAYOUT CSS


horizontalContainerCSS : String
horizontalContainerCSS =
    """
    .container-layout {
        min-height: 100vh;
    }

    .scroll-container {
        overflow-x: auto !important;
        overflow-y: auto !important;
        scrollbar-width: thin;
        scrollbar-color: #CBD5E0 #F7FAFC;
    }

    .scroll-container::-webkit-scrollbar {
        height: 10px;
    }

    .scroll-container::-webkit-scrollbar-track {
        background: #F7FAFC;
        border-radius: 5px;
    }

    .scroll-container::-webkit-scrollbar-thumb {
        background: #CBD5E0;
        border-radius: 5px;
    }

    .scroll-container::-webkit-scrollbar-thumb:hover {
        background: #A0AEC0;
    }

    /* Navigation buttons responsive layout */
    .nav-buttons-row {
        flex-wrap: wrap;
        justify-content: center;
    }

    /* Responsive button container - row on desktop, column on mobile */
    .responsive-button-container {
        display: flex !important;
        flex-direction: row !important;
        justify-content: center !important;
        align-items: center !important;
        gap: 20px !important;
    }

    @media (max-width: 768px) {
        .responsive-layout {
            padding: 20px 16px !important;
        }
        
        .responsive-container {
            gap: 20px !important;
        }
        
        .responsive-button-container {
            flex-direction: column !important;
            gap: 16px !important;
        }
        
        .nav-buttons-row {
            gap: 8px !important;
        }
        
        .nav-buttons-row button {
            min-width: 80px;
            padding: 8px 12px !important;
            font-size: 12px !important;
        }
        
        .container-layout {
            padding: 10px 15px;
        }
    }

    @media (max-width: 480px) {
        .responsive-layout {
            padding: 16px 12px !important;
        }
        
        .responsive-button-container {
            flex-direction: column !important;
            gap: 12px !important;
        }
        
        .nav-buttons-row {
            gap: 6px !important;
        }
        
        .nav-buttons-row button {
            min-width: 70px;
            padding: 6px 10px !important;
            font-size: 11px !important;
        }
        
        .container-layout {
            padding: 10px;
        }
    }
    """