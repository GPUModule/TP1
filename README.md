## TP1 : Convolution et mémoire partagée

Ce tp est à rendre pour dimanche 13 mars 2022 24:00 date limite.
A rendre par mail à elias.munoz@univ-amu.fr avec pour sujet : [M1 GPU] TP1.

**Pensez à renseigner votre NOM et Prénom dans le corps du mail.**
**Pour ce TP, vous pouvez vous mettre en groupe de 2, dans ce cas renseignez le nom et prénom des deux membres du binôme**

#### Google Colab
Pour les étudiants n'ayant pas de carte graphique nvidia, le mieux est de creer un compte **google colab**.
https://colab.research.google.com/?hl=fr

Avec google colab, vous avez accès gratuitement à un GPU et pouvez coder directement depuis un jupyter notebook. Vous n'aurez pas à compiler le programme, mais juste à executer la cellule ou vous avez écrit le code.

Une fois connecté à google colab, importez le fichier .ipnyb présent dans le code source. 

Ensuite, pour activer le GPU, aller dans Exécution -> Modifier le type d'exécution -> Selectionnez GPU.

#### Exercice 1
Vous travaillerez sur le fichier exercice01.cu ou alors dans l'avant dernière cellule du fichier .ipnyb sur google colab.

##### Simple convolution 1D

La convolution est une opération permettant d'alterer une image en faisant glisser un filtre sur cette image. Cela peut permettre d'ajouter du flou sur l'image, de detecter des contour et bien d'autres.

![Convolution1D étapte 1](conv1.png)

![Convolution1D étapte 2](conv2.png)

![Convolution1D étapte 3](conv3.png)

![Convolution1D étapte 4](conv4.png)

Dans le code, nous avons un tableau **a** de **N** éléments. On veut lui faire glisser un **filtre** de taille **f** = 3.

Pour trouver la taille du tableau résultant, il suffit de faire **n_c = N - f + 1**

Une fonction random_floats est fournit permettant d'initialiser un tableau de taille n.

1. Pour commencer, remplissez la fonction main avec
	1. N = 6, f=3, n_c = N - f + 1
	2. blockPerGrid(1)
	3. threadsPerBlock(6)
2. Completez la fonction simple_convolution_1D
3. Executez le code

Le programme doit afficher un tableau **a** de 6 éléments, un filtre **filter** de 3 éléments et le résultat **c** de 4 éléments.

Vérifiez si le résultat est correct.

4. Changez la dimensiom de blocksPerGrid par (N + THREADS_PER_BLOCK -1)/THREADS_PER_BLOCK
5. Changez la dimensiom de threadsPerBlock par threadsPerBlock par THREADS_PER_BLOCK
6. Commentez les **printf()** pour éviter un affichage lourd 
7. Changez N par 2048
8. Exécuter le programme

##### Shared convolution 1D
Le but ici est d'implementer un convolution 1D en utilisant la mémoire partagée. 

Les nouvelles dimensions de blocksPerGrid et threadsPerBlock modifié plus haut permettent de diviser notre tableau en un nombre de block de même dimensions.

Chaque block va calculer sa partie du tableau.
Pour rappel chaque threads a accès a la mémoire partagé de son block, mais les blocks ne partagents pas cette mémoire entre eux.

9. Dans le main:
	1. Créez un nouveau tableau **cs** et **d_cs** de même dimension que c pour stocker les résultats de la convolution.
10. Compléter shared_convolution_1D :
	2. Créez un tableau $\_\_shared\_\_$ **s_data** de la taille d'un block.
	3. Initialisez le tableau en lui ajoutant les éléments de **a** que le block va traiter.
		1. N'oubliez pas de synchroniser avec $\_\_syncthread()$ après initialisation.
	4. Modifier le code afin de pouvoir utiliser cette mémoire partagé.
11. Récupérer le résultat **d_cs** dans **cs**
12. Decommentez **errors = validate(c, cs, n_c)**; et **printf("CUDA GPU result has %d errors.\n", errors);**
13. Executez le programme.

L'etape 12 permets de comparer le résultat de la convolution simple utilisant la mémoire globale et de la convolution simple utilisant la mémoire partagée.

Si le résultat des deux kernels sont différents, modifiez le kernel shared_convolution1D jusqu’à avoir un resultat identique.

Faites attentions aux limites du tableau **s_data**, chaque block creer un tableau **s_data** de taille le nombre de threads de ce block. il récupère la sous-partie correspondante du tableau **a** dans **s_data** et réalise ensuite la convolution.
Les threads d'un block n'ont pas accès au tableau **s_data** d'autres blocks.

Quel implementation est plus rapide ? de beaucoup ?
Qu'elle sont les types de mémoire encore utilisé dans le shared_convolution1D ?

Exercice 2 (Bonus):

Cet exercice est un bonus pour si vous voulez implementer une convolution 2D (peut-être utile si vous faites de l'IA).

![Convolution2D](conv2D.png)

Réalisez les même opération mais avec des convolutions 2D avec :
dim3 threadsPerBlock(THREADS_PER_BLOCK)
dim3 blocksPerGrid(N/THREADS_PER_BLOCK, N/THREADS_PER_BLOCK)

Un guide sur les convolutions sous format pdf est inclu dans le répertoire git (en anglais). 
