# iOS-PokeExplorer

iOS-PokeExplorer é um aplicativo para iOS que funciona como uma Pokédex moderna, permitindo aos usuários explorar o mundo dos Pokémon. O projeto foi desenvolvido utilizando tecnologias modernas da Apple, como SwiftUI e SwiftData, e integra-se com Firebase para funcionalidades de backend.

O foco do projeto é demonstrar a construção de uma aplicação robusta, com uma arquitetura bem definida (MVVM), interface de usuário responsiva e funcionalidades essenciais como autenticação e persistência de dados.

## Funcionalidades

* **Autenticação de Usuários:** Sistema completo de registro e login utilizando Firebase Authentication.
* **Perfil de Usuário:** Tela de perfil onde as informações do usuário logado são exibidas.
* **Lista de Pokémon:** Visualização de uma lista de Pokémon carregada a partir da PokéAPI.
* **Rolagem Infinita:** A lista carrega mais Pokémon automaticamente conforme o usuário rola, otimizando o uso de rede e memória.
* **Busca e Filtragem:** Campo de busca para filtrar a lista de Pokémon em tempo real.
* **Detalhes do Pokémon:** Tela de detalhes para cada Pokémon, com animações de transição suaves.
* **Interface Responsiva:** O layout se adapta dinamicamente a diferentes tamanhos de tela e orientações, oferecendo uma boa experiência tanto em iPhones (vertical e horizontal) quanto em iPads.
* **Persistência Local:** Utilização do SwiftData para armazenar dados localmente de forma eficiente.

## Tecnologias e Arquitetura

* **Linguagem:** Swift
* **Interface:** SwiftUI
* **Arquitetura:** Model-View-ViewModel (MVVM)
* **Backend (BaaS):** Google Firebase
    * **Firebase Authentication:** Para gerenciamento de contas de usuário.
    * **Cloud Firestore:** Para armazenar dados dos usuários (como nome).
* **Armazenamento Local:** SwiftData
* **API Externa:** PokéAPI (para obter os dados dos Pokémon)
* **Concorrência:** Async/Await para operações de rede assíncronas.
* **Gerenciamento de Dependências:** Swift Package Manager

## Estrutura do Projeto

O código está organizado seguindo o padrão MVVM para garantir a separação de responsabilidades e facilitar a manutenção:

* **Models:** Representam os tipos de dados da aplicação (ex: `Pokemon`, `User`).
* **Views:** Camada de interface do usuário, construída com SwiftUI (ex: `PokemonListView`, `LoginView`).
* **ViewModels:** Contêm a lógica de apresentação e o estado da UI, servindo como uma ponte entre os Models e as Views.
* **Managers:** Classes responsáveis por gerenciar serviços específicos, como autenticação (`AuthManager`) ou chamadas de rede.

## Como Executar o Projeto

Para compilar e executar este projeto localmente, siga os passos abaixo.

### Pré-requisitos

* macOS Sonoma 14.0 ou superior
* Xcode 15.0 ou superior

### Configuração do Firebase

Este projeto utiliza Firebase para autenticação e banco de dados. Para executá-lo, você precisará configurar seu próprio ambiente no Firebase.

1.  Acesse o [console do Firebase](https://console.firebase.google.com/).
2.  Crie um novo projeto.
3.  Adicione um novo aplicativo iOS ao seu projeto Firebase, seguindo as instruções para registrar o Bundle ID (`com.example.iOS-PokeExplorer` ou o que você preferir).
4.  Baixe o arquivo de configuração `GoogleService-Info.plist`.
5.  No menu do Firebase, vá para **Authentication** e habilite o provedor **Email/Senha**.
6.  Vá para **Firestore Database**, crie um banco de dados e inicie em modo de produção ou teste.

### Passos para Execução

1.  Clone este repositório para a sua máquina local:
    ```sh
    git clone [https://github.com/TheoRavaglia/iOS-PokeExplorer.git](https://github.com/TheoRavaglia/iOS-PokeExplorer.git)
    ```
2.  Abra o projeto no Xcode:
    ```sh
    cd iOS-PokeExplorer
    open iOS-PokeExplorer.xcodeproj
    ```
3.  Arraste o arquivo `GoogleService-Info.plist` que você baixou do Firebase para a pasta `iOS-PokeExplorer` dentro do navegador de arquivos do Xcode. Certifique-se de que a opção "Copy items if needed" está marcada.
4.  Selecione um simulador de iPhone ou iPad e pressione **Cmd+R** para compilar e executar o aplicativo.
