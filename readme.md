# iOS-PokeExplorer

iOS-PokeExplorer é um aplicativo para iOS que funciona como uma Pokédex moderna, permitindo aos usuários explorar o mundo dos Pokémon. O projeto foi desenvolvido inteiramente com tecnologias nativas da Apple, demonstrando uma aplicação robusta e autocontida.

O foco do projeto é exibir a construção de uma aplicação utilizando SwiftUI para a interface, uma arquitetura bem definida (MVVM) para a lógica, e SwiftData/Core Data para toda a persistência de dados, incluindo o sistema de autenticação de usuários.

## Funcionalidades

* **Autenticação de Usuários Local:** Sistema completo de registro e login com credenciais armazenadas de forma segura e local no dispositivo através do SwiftData.
* **Perfil de Usuário:** Tela de perfil onde as informações do usuário logado são exibidas.
* **Lista de Pokémon:** Visualização de uma lista de Pokémon carregada a partir da PokéAPI.
* **Rolagem Infinita:** A lista carrega mais Pokémon automaticamente conforme o usuário rola, otimizando o uso de rede e memória.
* **Busca e Filtragem:** Campo de busca para filtrar a lista de Pokémon em tempo real.
* **Detalhes do Pokémon:** Tela de detalhes para cada Pokémon, com animações de transição suaves.
* **Interface Responsiva:** O layout se adapta dinamicamente a diferentes tamanhos de tela e orientações, oferecendo uma boa experiência tanto em iPhones (vertical e horizontal) quanto em iPads.
* **Persistência de Dados Nativa:** Utilização do Core Data e da API SwiftData para armazenar todos os dados da aplicação de forma eficiente.

## Tecnologias e Arquitetura

* **Linguagem:** Swift
* **Interface:** SwiftUI
* **Arquitetura:** Model-View-ViewModel (MVVM)
* **Armazenamento de Dados:**
    * **Core Data:** Framework de persistência de dados da Apple.
    * **SwiftData:** API moderna sobre o Core Data para gerenciamento de dados.
* **API Externa:** PokéAPI (para obter os dados dos Pokémon)
* **Concorrência:** Async/Await para operações de rede assíncronas.
* **Gerenciamento de Dependências:** Swift Package Manager

## Estrutura do Projeto

O código está organizado seguindo o padrão MVVM para garantir a separação de responsabilidades e facilitar a manutenção:

* **Models:** Representam os tipos de dados da aplicação (ex: `Pokemon`, `User`).
* **Views:** Camada de interface do usuário, construída com SwiftUI (ex: `PokemonListView`, `LoginView`).
* **ViewModels:** Contêm a lógica de apresentação e o estado da UI, servindo como uma ponte entre os Models e as Views.
* **Managers:** Classes responsáveis por gerenciar serviços específicos, como a lógica de autenticação local.

## Como Executar o Projeto

Como o projeto utiliza apenas frameworks nativos da Apple e não depende de serviços externos para funcionar, a sua execução é bastante simples.

### Pré-requisitos

* macOS Sonoma 14.0 ou superior
* Xcode 15.0 ou superior

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
3.  Selecione um simulador de iPhone ou iPad e pressione **Cmd+R** para compilar e executar o aplicativo. Nenhuma configuração adicional é necessária.

