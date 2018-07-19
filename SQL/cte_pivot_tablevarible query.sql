-- 7/17/2018 Code Below is replacement of global temp table use : 

DECLARE @GLB_TempItemStndCostPivot TABLE (
    ProductID varchar(47),
    MaterialCost decimal(15, 4),
    LaborCost decimal(15, 4),
    OverheadCost decimal(15, 4),
    SubcontractedCost decimal(15, 4),
    TotalCost decimal(15, 4)
) DECLARE @TempItemMaster TABLE (
    ProductID varchar(47),
    CostComponent varchar(8),
    EffectiveDate datetime,
    AmountBaseCurrency float
)
 


INSERT INTO
    @TempItemMaster(
        ProductID,
        CostComponent,
        EffectiveDate,
        AmountBaseCurrency
    )
SELECT
    ISC.ProductID,
    ISC.CostComponent,
    ISC.EffectiveDate,
    ISC.AmountBaseCurrency
FROM
    ln.ItemStandardCostL ISC
    INNER JOIN (
        SELECT
            ISC.ProductID,
            MAX(ISC.EffectiveDate) AS MaxDateTime
        FROM
            ln.ItemStandardCostL ISC
        GROUP BY
            ISC.ProductID
    ) groupedtt ON ISC.ProductID = groupedtt.ProductID
    AND ISC.EffectiveDate = groupedtt.MaxDateTime
	
	;with tempCTE (
        ProductID,
        [100],
        [200],
        [205],
        [210],
        [220],
        [299],
        [300],
        [500],
        [600],
        [605],
        [610],
        [620],
        [700],
        [900]
    ) as (
        select
            *
        FROM
            (
                SELECT
                    ProductID,
                    CostComponent,
                    AmountBaseCurrency
                FROM
                    @TempItemMaster
            ) src PIVOT (
                sum(AmountBaseCurrency) for CostComponent in (
                    [100],
                    [200],
                    [205],
                    [210],
                    [220],
                    [299],
                    [300],
                    [500],
                    [600],
                    [605],
                    [610],
                    [620],
                    [700],
                    [900]
                )
            ) piv
    )
    /** Step 3 **/
insert into
    @GLB_TempItemStndCostPivot(
        ProductID,
        MaterialCost,
        LaborCost,
        OverheadCost,
        SubcontractedCost,
        TotalCost
    )
SELECT
    ProductID,
    MaterialCost,
    LaborCost,
    OverheadCost,
    SubcontractedCost,
    SUM(TotalCost) AS TotalCost
FROM
    (
        Select
            ProductID,
            isnull([100], 0) as MaterialCost,
            sum(
                cast(COALESCE([100], 0) as decimal(15, 4)) + cast(COALESCE([200], 0) as decimal(15, 4)) + cast(COALESCE([205], 0) as decimal(15, 4)) + cast(COALESCE([210], 0) as decimal(15, 4)) + cast(COALESCE([220], 0) as decimal(15, 4)) + cast(COALESCE([299], 0) as decimal(15, 4)) + cast(COALESCE([500], 0) as decimal(15, 4)) + cast(COALESCE([600], 0) as decimal(15, 4)) + cast(COALESCE([605], 0) as decimal(15, 4)) + cast(COALESCE([610], 0) as decimal(15, 4)) + cast(COALESCE([620], 0) as decimal(15, 4)) + cast(COALESCE([700], 0) as decimal(15, 4)) + cast(COALESCE([900], 0) as decimal(15, 4))
            ) as TotalCost,
            sum(
                cast(COALESCE([200], 0) as decimal(15, 4)) + cast(COALESCE([205], 0) as decimal(15, 4)) + cast(COALESCE([210], 0) as decimal(15, 4)) + cast(COALESCE([220], 0) as decimal(15, 4)) + cast(COALESCE([299], 0) as decimal(15, 4))
            ) as LaborCost,
            sum(
                cast(COALESCE([500], 0) as decimal(15, 4)) + cast(COALESCE([600], 0) as decimal(15, 4)) + cast(COALESCE([605], 0) as decimal(15, 4)) + cast(COALESCE([610], 0) as decimal(15, 4)) + cast(COALESCE([620], 0) as decimal(15, 4)) + cast(COALESCE([900], 0) as decimal(15, 4))
            ) as OverheadCost,
            isnull([700], 0) as SubcontractedCost
        FROM
            tempCTE
        GROUP BY
            ProductID,
            [100],
            [700]
    ) A
GROUP BY
    ProductID,
    MaterialCost,
    LaborCost,
    OverheadCost,
    SubcontractedCost
select
    ProductID,
    MaterialCost,
    LaborCost,
    OverheadCost,
    SubcontractedCost,
    TotalCost
from
    @GLB_TempItemStndCostPivot

