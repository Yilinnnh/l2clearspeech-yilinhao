library(readr)

# 读取 CSV 文件
n1 <- read_csv("~/Desktop/ma_thesis/N-NN.csv")
n2 <- read_csv("~/Desktop/ma_thesis/NN1-NN1.csv")
n3 <- read_csv("~/Desktop/ma_thesis/NN1-NN2.csv")

# 为每个数据集添加组别标识
n1$group <- "n1"
n2$group <- "n2"
n3$group <- "n3"

# 合并三个数据集，只保留 f0 和组别信息
data_all <- rbind(n1[, c("vowel_duration", "group")],
                  n2[, c("vowel_duration", "group")],
                  n3[, c("vowel_duration", "group")])

# 执行 Kruskal-Wallis 检验
result <- kruskal.test(vowel_duration ~ group, data = data_all)
print(result)

