#install.packages("pipeR")
library(pipeR)

# Tải các packages cần cho phân tích:
#c("arules", "arulesViz", "arulesNBMiner", "arulesSequences") %>>%
#  install.packages()
c("arules", "arulesViz", "arulesNBMiner", "arulesSequences") %>>%
  sapply(require, character.only = T)

# Sử dụng dữ liệu groceries:
data("Groceries")
str(Groceries)

# kiểm tra thông tin về items trong Groceries
Groceries %>>%
  itemLabels() %>>%
  head(20)
Groceries %>>%
  itemInfo() %>>%
  head(20)
gro.info <- itemInfo(Groceries)

#1. Kiểm tra các item phổ biến
Groceries %>>%
  itemFrequency(type = "absolute") %>>%
  as.data.frame() %>>%
  (~ gro.itemfreq) %>>% # đặt tên bảng các items phổ biến
  head(10)
colnames(gro.itemfreq) <- "freq"
gro.itemfreq$item <- rownames(gro.itemfreq) # bổ sung cột itemnames cho bảng gro.itemfreq

# bổ sung thông tin về frequency từ bảng gro.itemfreq vào bảng gro.info:
gro.info.new <- merge(gro.info, gro.itemfreq, by.x = "labels", by.y = "item", all.x = T)
str(gro.info.new)
gro.info.new <- gro.info.new[order(gro.info.new$freq, decreasing = T),1:4]
head(gro.info.new, 20)

# vẻ barchart đơn giản về các item phổ biến nhất:
itemFrequencyPlot(Groceries, type = "absolute", topN = 20, decreasing = T)


#2. Tạo rules:
#2.a. Sử dụng Apriori:sử dụng hàm apriori trong gói arules
#++++++++++Note về hàm apriori:
# Parameters: min sup: 0.001 (1%); min conf = 0.8 (80%); các chỉ số khác của rules: LHS...
# Appearance: lựa chọn xuất hiện của items (có thể lọc bỏ hoặc chỉ lấy một số items nhất định theo mong muốn của users 
# - do không thật sự quan tâm hoặc rất quan tâm)
# Control: liên quan đến việc tính toán rules: có sắp xếp tần suất hay không (sort), thông báo quá trình chạy (verbose)
#++++++++++++++++++++++++++++++

# Tạo rules bằng phương pháp apriori
Groceries %>>%
  apriori(parameter = list(supp = 0.001, conf = 0.8, arem = "diff", aval = T, ext = T)
          #, appearance = list() 
          , control = list(verbose = T, sort = 1) 
  ) %>>%
  (~ rule.ap) # đặt tên cho rules

# Kiểm tra rules:
rule.ap %>>%
  sort(by = "lift") %>>%
  head(20) %>>% # lấy 20 có chỉ số lift tốt nhât
  inspect # kiểm tra 20 rules này
str(rule.ap) # có tổng cộng 410 rules

rule.ap@quality %>>%
  head(20) # kiểm tra các chỉ số của rule.ap
rule.ap@info # thông tin cơ bản của rule.ap

# Loại bỏ các rules bị lặp lại:
#rule.ap.sub <- is.subset(rule.ap, rule.ap) # tạo ra matrix logical đánh giá các rules nào là tập con của rules nào.
#rule.ap.sub[1:2, 1:2] # kiểm tra 4 giá trị của matrix
#rule.ap.sub[lower.tri(rule.ap.sub, diag = T)] <- NA # chuyển các giá trị nửa dưới của matrix thành NA
#rule.ap.red <- colSums(rule.ap.sub, na.rm = T) >= 1 # lấy tất các những giao dịch là tập con của các giao dịch khác (số lần logical = TRUE >= 1)
#rule.ap.sprune <- rule.ap[!rule.ap.red]
#str(rule.ap.sprune) # chỉ còn lại 169 rules so với 410 rules ban đầu
#rule.ap.sprune@quality %>>%
#  head(20)

#2.b sử dụng hàm eclat trong gói arules
#+++++++++Note về hàm eclat:
# parameters: tương tự với apriori: min support/confidence, maxlen
# Control: tương tự với apriori
#++++++++++++++++++++++++++++++++++
rule.ec <- eclat(Groceries
                 , parameter = list(supp = 0.001, ext = T)
                 , control = list(sort = 1) 
)
str(rule.ec)
rule.ec %>>%
  sort(by = "support") %>>%
  head(20) %>>%
  inspect



#3. Vẽ đồ thị với rule.ap.sprun: sử dụng hàm plot từ gói arulesViz
#3.1 Đồ thị scatter plot đơn giản
#rule.ap.sprune
plot(rule.ap)
rule.ap %>>%
  plot(method = "two-key plot")

plot(rule.ec)

#3.2 Đồ thị dạng matrix
rule.ap %>>%
  plot(method = "matrix", measure = "lift")

rule.ap %>>%
  plot(method = "matrix", measure = c("lift", "confidence"))

#3.3 Đồ thị nhóm
rule.ap %>>%
  plot(method = "group")

#3.4 Đồ thị dạng bong bóng
rule.ap %>>% 
  head(10) %>>% # chỉ lấy 20 rules tốt nhất
  plot(method = "graph") 

#3.5 Đồ thị Paracoord
rule.ap %>>%
  head(20) %>>% # chỉ lấy 20 rules tốt nhất
  plot(method = "paracoord")

#3.6 Đồ thị mosaic
rule.ap %>>%
  plot(method = "iplots")

#4. Đánh giá rules
rule.ap %>>%
  quality() %>>%
  head(20) # kiểm tra các chỉ số của rules

rule.ap %>>%
  interestMeasure(measure = c("support" # support of the rules
                              , "confidence" # confidence of the rules
                              , "lift" # lift meaure of rules
                              , "coverage" # LHS support
                              , "doc" # difference of confidence
                              , "cosine" # harmonised mearsure
                              #, "allConfidence" # min of {P(a|b), P(b|a)}
                              , "chiSquared"
                              , "Kulc" # Kulc measure
                              , "imbalance" # imbalance ratio
  )
  , transactions = Groceries) %>>%
  (~ inter.tb) # interest table used to cross check all measures to see which rules would bring out the best results
