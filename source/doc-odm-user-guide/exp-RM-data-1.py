#  Copyright (c) 2011-2023 Genestack Limited
#  All Rights Reserved
#  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF GENESTACK LIMITED
#  The copyright notice above does not evidence any
#  actual or intended publication of such source code.

curl -X POST "https://odm-demos.genestack.com/frontend/rs/genestack/expressionCurator/default-released/expression/gct" -H  "accept: application/json" -H  "Genestack-API-Token: <token>" -H  "Content-Type: application/json" -d "{  \"link\": \"https://bio-test-data.s3.amazonaws.com/Research_Model_BR-205/Test_RM_g.gct\",  \"metadataLink\": \"https://bio-test-data.s3.amazonaws.com/Research_Model_BR-205/Test_RM_g.gct.tsv\"}"
