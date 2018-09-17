# 1.Giới thiệu

Frequent Pattern Mining (FPM) là khái niệm được dùng trong việc phân tích các hành vi lặp đi lặp lại giữa các yêu tố có liên hệ với nhau. FPM được sử dụng đặc biệt rộng rãi trong các ngành như ecommerce, banking, retail... giúp người bán có thể phân tích hành vi mua sắm của khách hàng. Một số phương pháp được ứng dụng nhiều trong phân tích FPM như:

- Phương pháp Apriori
- Phương pháp Eclat (định dạng dữ liệu dọc - vertical data format)

# 2.Lý thuyết chung
## 2.1.Các khái niệm cơ bản
### 2.1.1.Market basket analysis (phân tích giỏ hàng)
Ví dụ bạn là chủ của một của hàng tạp hóa, bạn sẽ muốn biết được một khách hàng (KH) khi đến của hàng của mình sẽ mua những món đồ gì. Để làm được điều này, bạn cần nhìn vào dữ liệu về các giao dịch của KH, qua đó sẽ thấy được tần suất xuất hiện của các món đồ KH đã mua và những món đồ nào thường được KH mua trong cùng một lần mua sắm. Ví dụ, KH thường mua bia lon và đồ nhậu mỗi lần đến mua sắm tại của hàng tạp hóa của bạn, điều này thể hiện 2 đồ vật này đã tạo ra mối quan hệ (association rule) và mối quan hệ này có thể hỗ trợ bạn trong việc tiên đoán hành vi mua sắm tiếp theo của KH khi mua hàng.

### 2.1.2.Support và confidence
Giá dụ việc KH mua bia lon và đồ nhậu tại cửa hàng của bạn (dựa vào dữ liệu về giao dịch của KH) có xác suất là 2% tổng số giao dịch và cơ hội để KH mua thêm đồ nhậu khi đã mua bia là 80% vậy thì hàng vi mua sắm bia lon và đồ nhậu được miêu tả như sau:
Bia lon => đồ nhậu[support = 2%, confidence = 80%]

- Support: tần suất để hành vi mua sắm xuất hiện trong toàn bộ các giao dịch mua sắm của KH
- Confidence: cơ hội xảy ra việc mua sắm đồ vật tiếp theo trong chuỗi đồ mua sắm của hành vi
- Mức support tối thiểu (minimum support threshold): tần suất thấp nhất của hành vi để thỏa mãn được sự quan tâm của người phân tích
- Mức Confidence tối thiểu (minimum confidence threshold): mức thấp nhất của cơ hội mua sắm để thỏa mãn được sự quan tâm của người phân tích

### 2.1.3.Các khái niệm khác
Gọi I = {I1, I2,...,Im} là tập các đồ vật; D là dữ liệu giao dịch trong đó từng giao dịch T là giao dịch có các đồ vật thuộc tập I (![](/formula_gif/T_subset_I.gif)). A là tập các đồ vật, và ![](/formula_gif/A_subset_I.gif), ta có:

* ![](/formula_gif/for1.gif) 

Như vậy, để quy luật ![](/formula_gif/A_Rightarrow_B.gif) sẽ có 2 thành phần:

* ![](/formula_gif/for2.gif)

* ![](/formula_gif/for3.gif)

Trong đó, ![](/formula_gif/A_cup_B.gif) là tần suất xuất hiện hành vi mua sắm của cả A và B trong dữ liệu về giao dịch D ; ![](/formula_gif/A_mid_B.gif) là tần suất xuất hiện của hành vi mua sắm B với điều kiện đã có việc mua sắm A.

* ![](/formula_gif/for4.gif) (*)

(*): số lượng giao dịch của cả A và B/Số lượng giao dịch A

Về nguyên tắc, Association rules phải trải qua 2 bước:

* 1. Tìm tất cả các giao dịch (tập các đồ vật) phổ biến: các giao dịch này phải thỏa mãn điều kiện về mức support tối thiểu.

* 2. Tạo ra những Association rules mạnh từ các giao dịch phổ biến: các giao dịch có association rules mạnh phải thỏa mãn cả điều kiện về support tối thiếu và confidence tối thiểu.

_Ví dụ về dữ liệu giao dịch:_

ID giao dịch  |  Danh sách các đồ vật|
--------------|---------------------:|
T100          |  I1, I2, I5
T200          |  I2, I4
T300          |  I2, I3
T400          |  I1, I2, I4
T500          |  I1, I3
T600          |  I2, I3
T700          |  I1, I3
T800          |  I1, I2, I3, I5
T900          |  I1, I2, I3

## 2.2.Phương pháp Apriori:
### 2.2.1.Các khái niệm cơ bản của Apriori

* Mệnh đề của Apriori: _Tất cả các tập con không rỗng của một giao dịch phổ biến phải là phổ biến_

Có nghĩa là: nếu I là một giao dịch chứa các đồ vật, I không phải là một giao dịch phổ biến thì P(I) < mức support tối thiểu. Như vậy, nếu thêm một đồ vật X vào giao dịch I thì giao dịch J chứa cả I và X không thể là giao dịch phổ biến được, hay ![](/formula_gif/I_cup_X.gif) < mức support tối thiểu.

Phương pháp Apriori được thực thiện qua 2 bước: 1) xát nhập (join), 2) sàng lọc (prune)

* Xát nhập: để tìm được các giao dịch chứa k đồ vật, các giao dịch chứa k-1 đồ vật sẽ được sử dụng và xát nhập với nhau để tạo ra các giao dịch chứa k đồ vật. Để tránh bị trùng lặp trong quá trình xát nhập các giao dịch với nhau, các đồ vật trong các giao dịch được sắp xếp theo thứ thự từ A-Z.

* Sàng lọc: mục đích của bước sàng lọc là để lọc ra những giao dịch chứa k đồ vật thật sự phổ biến. Trong bược xát nhập, chúng ta đã có một danh sách dài các giao dịch chứa k đồ vật, công việc tiếp theo là đọc lại toàn bộ dữ liệu D về giao dịch để kiểm tra các giao dịch nào là phổ biến. Tuy nhiên, nếu thực hiện công việc như vậy thì sẽ tốn rất nhiều công sức. Do đó, chúng ta sử dụng mệnh đề của Apriori cho bước sàng lọc. Có nghĩa là trong các giao dịch chứa k-1 đồ vật mà không phải phổ biến, chúng ta sẽ loại bỏ toàn bộ các giao dịch chưa k đồ vật mà chứa toàn bộ k-1 đồ vật của các giao dịch trên. Như vậy, số lượng giao dịch chứa k đồ vật còn lại sẽ ít đi rất nhiều để thực hiện công việc đọc dữ liệu các giao dịch D.

### 2.2.2.Nhược điểm của Apriori và cách khắc phục
Apriori có nhược điểm lớn về hiệu suất, đặc biệt khi phải thực hiện thuật toán với những giao dịch phổ biến chưa nhiều đồ vật, như vậy, việc đọc dữ liệu các giao dịch D sẽ phải diễn ra nhiều lần. Ngoài ra, 

Một vài phương pháp khắc phục:

* Kỹ thuật phân nhóm (hashed-base): chia nhỏ tập các đồ vật thành các nhóm có thể được sử dụng để làm giảm số lượng các giao dịch chứa k đồ vật. Ví dụ, khi lựa chọn danh sách các giao dịch chứa 2 đồ vật (k = 2), sau khi chúng ta đã tìm ra được các giao dịch chứa 1 đồ vật là phổ biến, sử dụng các giao dịch này để tạo thành các nhóm đồ vật (2 đồ vật) riêng biệt là các nhóm nhỏ. Đến toàn bộ giao dịch cho các nhóm này. Nếu số lượng giao dịch của nhóm nào nhỏ hơn mức support tối thiểu, thì nhóm đó bị loại khỏi danh sách các giao dịch phổ biến.

* Thu nhỏ số lượng giao dịch (transaction reduction): với giao dịch có k đồ vật và không phải là giao dịch phổ biến thì k đồ vật này sẽ không thể nằm trong k+1 đồ vật của một giao dịch phổ biến được. Do đó, các giao dịch không phổ biến này có thể được loại bỏ khỏi dữ liệu giao dịch D, trong các lần kiểm tra giao dịch chưa nhiều hơn k đồ vật tiêp theo.

* Tạo vách ngăn (partitioning): phương pháp này được sử dụng để chia dữ liệu giao dịch D thành các vách nhỏ (n partitions) không trùng lặp nhau. Đối với từng vách ngăn, ta sẽ tìm ra được các giao dịch phổ biến thỏa mãn mức support tối thiểu (tỷ lệ). Như vậy, để trở thành giao dịch phổ biến trong toàn bộ dữ liệu giao dịch D thì chắc chắn giao dịch phải phải giao dịch phổ biến trong ít nhất 1 vách ngăn. Sau đó danh sách các giao dịch phổ biến của từng vách ngăn được tập hợp lại để thực hiện việc đọc dữ liệu một lần nữa trên toàn bộ dữ liệu giao dịch D để tìm ra được các giao dịch phổ biến nhất.

* Phương pháp chọn tập con (sample): ý tưởng của việc chọn tập con (S) của toàn bộ dữ liệu giao dịch D là để sử dụng S làm đại diện cho D, sau đó, việc tim giao dịch phổ biến chỉ cần diễn ra trên S sau đó áp dụng ra cho D. Tuy nhiên, phương pháp này có thể khiến chúng ta bỏ sót một vài giao dịch phổ biến. Để khắc phục được tình huống này thì chúng ta có thể hạ thấp mức support tối thiểu, làm tăng số lượng giao dich phổ biến trong S. 

## 2.3.Phương pháp Định dạng dữ liệu dọc (Vertical Data Format)
### 2.3.1.Các khải niệm cơ bản

Đối với phương pháp Apriori, thì dữ liệu được sử dụng dưới định dạng nằm ngang, có nghĩa là danh sách các đồ vật trong giao dịch được liệt kê theo thứ tự từ trái sang phải trên cùng một dòng. 
Đối với phương pháp VDF, dữ liệu được thể hiện dưới dạng: đồ vật-giao dịch, có nghĩa là ứng với từng đồ vật sẽ là giao dịch (id giao dịch) chứa đồ vật đó.

Để tìm được các giao dịch phổ biến cho dữ liệu dạng VDF, chúng ta cần sử dụng thuật toán Eclat (Equivalence Class Transformation). Ví dụ về dạng dữ liệu VDF:

_1. Đồ vật trong VDF:_

Đồ vật     |  Giao dịch                                  |
-----------|--------------------------------------------:|
I1         |   {T100; T400; T500; T700; T800; T900}  
I2         |   {T100; T200; T300; T400; T600; T800; T900}
I3         |   {T300; T500; T600; T700; T800; T900}
I4         |   {T200; T400}
I5         |   {T100; T800}

_2. Đồ vật trong VDF:_

Đồ vật     |   Giao dịch                |
-----------|---------------------------:|
{I1,I2}    |   {T100; T400; T800; T900}  
{I1,I3}    |   {T500; T700; T800; T900}
{I1,I4}    |   {T400}
{I1,I5}    |   {T100; T800}
{I2,I3}    |   {T300; T600; T800; T900}
...        | 


_3. đồ vật trong VDF:_

Đồ vật      |   Giao dịch   |
------------|--------------:|
{I1,I2,I3}  |  {T800; T900}  
{I1,I2,I5}  |  {T100; T800}

Như vậy bước đầu tiên trong việc phân tích VDF là chyển hóa dữ liệu dạng liệt kê giao dịch (HDF) thành dạng liệt kê đồ vật. Dữ liệu giao dịch ban đầu sẽ được đọc qua để liệt kê toàn bộ danh sách các đồ vật có trong tất cả các giao dịch. Tương ứng với từng đồ vật sẽ là các giao dịch đã phát sinh chưa các đồ vật này. 
Từ danh sách này, chúng ta có thể biết được những đồ vật nào được mua thường xuyên, thỏa mãn mức suport tối thiểu. Sau đó, sử dụng phương pháp tương tự như Apriori để xác định các cặp có 2 đồ vật từ những đồ vật được mua phổ biến ở bước trên. Dựa vào danh sách đồ vật và giao dịch từ bước trên, chúng ta có thể lọc ra các cặp đồ vật được mua thường xuyên...
Quy trình này sẽ tiếp tục cho đến khi không còn phát sinh danh sách đồ vật được mua thỏa mãn mức support tối thiểu.

Điểm lợi thế của phương pháp này nằm ở chỗ ngoài việc sử dụng mệnh đề của phương pháp Apriori để xây dựng được danh sách k+1 đồ vật từ danh sách k đồ vật được mua sắm thường xuyên (thỏa mãn mức support tối thiểu), thì phương pháp này cũng cho phép hạn chế số lần đọc bảng dữ liệu giao dịch D khi tìm kiếm thêm danh sách k+1 đồ vật từ danh sách k đồ vật. Do tất cả các giao dịch chứa k đồ vật ở bước trước đã chưa toàn bộ thông tin cần thiết để sử dụng cho việc lên danh sách k+1 đồ vật.


## 2.4.Phương pháp đánh giá thuật toán
Ở trên chúng ta đã được đi qua 2 dạng thuật toán cơ bản là Aprirori và Eclat để phân tích hành vi mua sắm. Cả hai phương pháp này đều sử dụng mô hình support và confidence, như vậy, những giao dịch thỏa mãn mức support/confidence tối thiểu thì có thể được coi là hành vi mua sắm thường xuyên. Tuy nhiên, với mô hình này thì không tránh khỏi việc đưa ra kết luận chưa chính xác về hành vi mua sắm.

### 2.4.1.Mô hình tốt không đồng nghĩa với việc có ý nghĩa
Bây giờ chúng ta cùng đi qua ví dụ sau đây: Giả sử có 1000 giao dịch trong dữ liệu giao dịch D, trong đó có 600 giao dịch bao gồm rượu vang, 750 giao dịch bao gồm chai nước lọc và 400 giao dịch bao gồm cả rượu vang và chai nước lọc. Giả sử, bạn muốn tìm mối liên hệ trong dữ liệu và sử dụng mức support/confidence thất nhất lần lượt là: 30% và 60%.

Dựa trên dữ liệu ở trên, ta có thể tìm được liên hệ giữa việc mua sắm rượu vang và chai nước lọc như sau:

![](/formula_gif/for5.gif)

[support = 40%; confidence = 66%]

Cụ thể là:

* ![](/formula_gif/for6.gif)

* ![](/formula_gif/for7.gif)

Tuy nhiên, từ số liệu ở trên, bạn cũng có thể thấy được rằng tần suất mua chai nước lọc là 75% ![](/formula_gif/for8.gif) lớn hơn cả 66%.Rõ ràng chúng ta có thể thấy được rược vang và nước lọc có quan hệ nghịch chiều với nhau dựa vào các con số trên.

### 2.4.2.Từ phân tích quan hệ đến phân tích tương quan
Ví dụ trên cho thấy nếu chỉ phụ thuộc vào support và confidence thôi thì chưa đủ, để mô hình có tính thuyết phục cao, chúng ta cần thêm vào mô hình yếu tố tương quan (correlation), như vậy, mô hình của chúng ta sẽ như sau:

![](/formula_gif/for9.gif)

Có một vài chỉ số tương quan có thể được sử dụng trong mô hình như:

* ![](/formula_gif/for10.gif)
, nếu A và B là độc lập với nhau thì ![](/formula_gif/for11.gif), Lift = 1, nếu Lift < 1 A, B có tương quan nghịch đảo, và Lift > 1 thì A, B có tương quan cùng chiều.

* ![](/formula_gif/for12.gif)

* all confidence: ![](/formula_gif/for13.gif)

* max confidence: ![](/formula_gif/for14.gif)

* Kulczynski: ![](/formula_gif/for15.gif)

* Cosine (harmonised lift): ![](/formula_gif/for16.gif)

* Imbalance ratio: ![](/formula_gif/for17.gif)

các chỉ số tương quan như Lift, Chisquare, all/max confidence hay cosine đều gặp phải vấn đề về các giao dịch trống (các giao dịch không phải là giao dịch chứa các đồ vật phổ biến), khiến cho giá trị tương quan không phản ánh đúng mối quan hệ thực sự giữa các đồ vật. Chỉ có chỉ số Kulc và IB là giải quyết được vấn đề này, do vậy được cho là cặp chỉ số tốt để kết hợp với nhau trong việc tìm ra tương quan chính xác giữa các đồ vật trong các giao dịch phổ biến.

#### Reference:
Jiawei Han, Micheline Kamber, Jian Pei, (2012) “Mining Frequent Patterns, Associations, and Correlations: Basic Concepts and Methods”; “ Advanced Pattern Mining”, in Jiawei Han, Micheline Kamber, Jian Pei (3rd ed.), *Data Mining Concepts and Techniques*, 225 Wyman Street, Waltham, MA 02451, USA: Elsevier Inc.

# 3.Ứng dụng

```r 
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
    rule.ap.sub <- is.subset(rule.ap, rule.ap) # tạo ra matrix logical đánh giá các rules nào là tập con của rules nào.
    rule.ap.sub[1:2, 1:2] # kiểm tra 4 giá trị của matrix
    rule.ap.sub[lower.tri(rule.ap.sub, diag = T)] <- NA # chuyển các giá trị nửa dưới của matrix thành NA
    rule.ap.red <- colSums(rule.ap.sub, na.rm = T) >= 1 # lấy tất các những giao dịch là tập con của các giao dịch khác (số lần logical = TRUE >= 1)
    rule.ap.sprune <- rule.ap[!rule.ap.red]
    str(rule.ap.sprune) # chỉ còn lại 370 rules so với 410 rules ban đầu
    rule.ap.sprune@quality %>>%
      head(20)

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
    plot(rule.ap.sprune)
    rule.ap.sprune %>>%
      plot(method = "two-key plot")
    
    plot(rule.ec)

  #3.2 Đồ thị dạng matrix
    rule.ap.sprune %>>%
      plot(method = "matrix", measure = "lift")
    
    rule.ap.sprune %>>%
      plot(method = "matrix", measure = c("lift", "confidence"))
    
  #3.3 Đồ thị nhóm
    rule.ap.sprune %>>%
      plot(method = "group")
    
  #3.4 Đồ thị dạng bong bóng
    rule.ap.sprune %>>% 
      head(10) %>>% # chỉ lấy 20 rules tốt nhất
      plot(method = "graph") 
    
  #3.5 Đồ thị Paracoord
    rule.ap.sprune %>>%
      head(20) %>>% # chỉ lấy 20 rules tốt nhất
      plot(method = "paracoord")
    
  #3.6 Đồ thị mosaic
    rule.ap.sprune %>>%
      plot(method = "iplots")

#4. Đánh giá rules
  rule.ap.sprune %>>%
    quality() %>>%
    head(20) # kiểm tra các chỉ số của rules
  
  rule.ap.sprune %>>%
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
```
