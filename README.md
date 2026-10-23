# dbt, niveau 1

Code et données du cours en ligne [« dbt, niveau 1 »](https://www.docteuratomic.com) de
Docteur Atomic.

Le dépôt est le projet dbt que vous construisez pendant le cours. Chaque module commence et
finit sur une étiquette Git : `module-02-start` est l'état du projet au début du module 2,
`module-02-end` son état à la fin. Pour reprendre le cours à un module :

```bash
git clone https://github.com/DocteurAtomic/dbt-niveau-1.git
cd dbt-niveau-1
git switch -c mon-travail module-02-start
```

## Installation

Le cours emploie `dbt-oss`, la distribution open source (Apache 2.0) de dbt v2, et DuckDB,
qui ne demande aucun serveur. Il faut [uv](https://docs.astral.sh/uv/) :

```bash
uv tool install dbt-oss
dbt --version
```

## Premier lancement

```bash
dbt run-operation load_raw --args '{batch: batch_1}'
dbt build
```

La première commande charge la première livraison des données dans le schéma `raw` du
fichier `pachadata.duckdb`. La seconde construit et teste le projet. Les données sont
décrites dans [`data/README.md`](data/README.md).

---

# dbt, level 1

Code and data of the Docteur Atomic online course "dbt, level 1". Each module starts and
ends on a Git tag (`module-02-start`, `module-02-end`). Install `dbt-oss` with
`uv tool install dbt-oss`, then run `dbt run-operation load_raw --args '{batch: batch_1}'`
and `dbt build`.
