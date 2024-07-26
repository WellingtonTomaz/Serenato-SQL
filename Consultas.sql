--Consulta 01 Traz um conjunto de dados de tabelas distintas usando o comando union--

SELECT nome, rua, bairro, cidade, estado, cep from fornecedores
UNION ALL
select nome, rua, bairro, cidade, estado, cep from colaboradores;

--Consulta 02 Ultilizando subquery para trazer dados do cliente baseado na data e hora do pedido

SELECT nome, telefone
from clientes
WHERE id = (
  SELECT idcliente
  FROM pedidos
  WHERE datahorapedido = '2023-01-02 08:15:00');
  
  
--Consulta 03 Ultilizando subquery para trazer dados dos clientes que compraram no mes 01
  
  SELECT nome FROM clientes
  WHERE id IN (  
    SELECT idcliente FROM pedidos 
  WHERE strftime('%m', datahorapedido) = '01');
  
--Consulta 04 Ordenar produtos que possuem preco acima do medio
  
SELECT nome, preco
FROM produtos
GROUP BY preco
HAVING preco > (SELECT AVG (preco) FROM produtos);

--Consulta 05 Verificando o nome dos clientes e seu ID de pedido ultilizando a junção INNER JOIN

SELECT c.nome, p.id, p.datahorapedido
from clientes c
INNER JOIN pedidos p on c.id = p.idcliente 

--Conuslta 06 Trazendo todos os itens que já foram pedidos ultilizando a junçaõ RIGHT JOIN

 SELECT pr.nome, ip.idproduto, ip.idpedido
 FROM itenspedidos ip
 RIGHT JOIN produtos pr
 ON pr.id = ip.idproduto

--Consulta 07 Trazendo produtos que foram vendidos no mes 10

SELECT pr.nome,  x.idproduto,  x.idpedido 
FROM(
    SELECT ip.idpedido, ip.idproduto
    FROM pedidos p
    JOIN itenspedidos ip 
    ON p.id = ip.idpedido
    WHERE strftime('%m', p.DataHoraPedido) = '10' ) x
RIGHT JOIN produtos pr
ON pr.id =  x.idproduto;


-- Consulta 08 Verificando clientes que não fizeram pedido no mes 10 usando a junção LEFT JOIN

SELECT c.nome, x.id
from clientes c
LEFT JOIN 
(
  SELECT p.id, p.idcliente
  from pedidos p
  WHERE strftime('%m', p.DataHoraPedido) = '10' )x
  ON c.id = x.idcliente
  WHERE x.idcliente is NULL;
  
  
--Consulta 09 Verificando valor total do pedido por cliente
  
SELECT p.id, c.nome, SUM(ip.precounitario) as ValorTotalPedido
FROM clientes c 
join pedidos p on c.id = p.idcliente
JOIN itenspedidos ip ON p.id = ip.idpedido
GROUP BY p.id, c.nome 

--Consulta 10 Verificando soma total de pedidos 

SELECT c.nome AS NomeCliente, SUM(ip.precounitario) AS SomaTotalPedidos
FROM clientes c
INNER JOIN Pedidos p 
ON c.ID = p.idcliente
INNER JOIN itenspedidos ip
On P.id = ip.idpedido
GROUP BY c.Nome;
  

--Consulta 11 Valor faturamento diario

SELECT DATE(datahorapedido) AS Dia, SUM(ip.precounitario) AS FaturamentoDiario
from pedidos p 
INNER JOIN itenspedidos ip ON p.id = ip.idpedido
GROUP BY Dia
Order By Dia;

  
--Criando uma trigger para automatizar a visualização do faturamento diario

CREATE TRIGGER CalculaFaturamentoDiario
AFTER INSERT ON itenspedidos
FOR EACH ROW
BEGIN
    -- Deletar todos os registros na tabela FaturamentoDiario
    DELETE FROM FaturamentoDiario;
    
    -- Inserir o novo faturamento diário calculado
    INSERT INTO FaturamentoDiario (Dia, FaturamentoTotal)
    SELECT DATE(p.datahorapedido) AS Dia, SUM(ip.precounitario) AS FaturamentoTotal
    FROM pedidos p
    JOIN itenspedidos ip ON p.id = ip.idpedido
    GROUP BY Dia
    ORDER BY Dia;
END;


--Consulta 12 Visualizando cliente com maior pedido 

SELECT p.idCliente, c.nome, SUM(ip.quantidade * ip.precounitario) as Valortotal 
FROM clientes c 
INNER JOIN pedidos p ON c.id = p.idcliente 
INNER JOIN itenspedidos ip ON p.id = ip.idpedido 
GROUP BY p.idCliente 
ORDER BY Valortotal DESC 
LIMIT 1;



  



  