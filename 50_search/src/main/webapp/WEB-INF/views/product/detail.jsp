<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/nav.jsp" />

<h2>Product Detail</h2>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Class</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Pno</td>
        <td id="pnoVal">${pvo.pno }</td>
      </tr>
      <tr>
        <td>Title</td>
        <td>${pvo.title }</td>
      </tr>
      <tr>
        <td>Writer</td>
        <td>${pvo.writer }</td>
      </tr>
      <tr>
        <td>Price</td>
        <td>${pvo.price }</td>
      </tr>
      <tr>
        <td>Regdate</td>
        <td>${pvo.regdate }</td>
      </tr>
      <tr>
        <td>Moddate</td>
        <td>${pvo.moddate }</td>
      </tr>
      <tr>
        <td>Readcount</td>
        <td>${pvo.readcount }</td>
      </tr>
      <tr>
        <td>Content</td>
        <td>${pvo.content }</td>
      </tr>
	  <!-- File List Part-->
      <c:if test="${pvo.flist.size() > 0 }">
         <tr>
            <td colspan="2">
               <ul class="list-group" id="fileZone">
                  <c:forEach items="${pvo.flist }" var="fvo">
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                     <c:choose>
                        <c:when test="${fvo.ftype > 0 }">
                           <img src="/upload/${fvo.savedir }/${fvo.uuid}_th_${fvo.fname}">
                        </c:when>
                        <c:otherwise>
                           <i class="fa fa-file-text-o" style="font-size:48px;color:red"></i>                           
                        </c:otherwise>
                     </c:choose>
                     <a href="/upload/${fvo.savedir }/${fvo.uuid}_${fvo.fname}">
                     <span class="badge badge-success badge-pill">${fvo.fname }</span>
                     </a>
                     </li>
                  </c:forEach>
               </ul>      
            </td>
         </tr>
      </c:if>
    </tbody>
    <c:if test="${ses.email eq pvo.writer }">
   		<tfoot>
   			<tr>
   				<td colspan="2">
   					<a href="/product/modify?pno=${pvo.pno }" 
   						class="btn btn-outline-warning">??????</a>
   					<button type="button" class="btn btn-outline-danger" id="delBtn">??????</button>
   				</td> 
   			</tr>
   		</tfoot>
   		<form action="/product/remove" id="delForm" method="post">
   			<input type="hidden" name="pno" value="${pvo.pno }">
   		</form>
   		<script>
   			$("#delBtn").on("click", function() {
   				$("#delForm").submit();
   			});
   		</script>
    </c:if>
  </table>

<!-- Ajax Comment Part -->
<h2 class="float-left">Comment List</h2>
<div class="form-group float-right ml-3">
    <form action="" class="form-inline">
        <select class="form-control" id="range">
            <option value="cwr">??????</option>
            <option value="c">??????</option>
            <option value="w">?????????</option>
            <option value="r">????????????</option>
            <option value="cw">??????+?????????</option>
        </select>
        <input class="form-control" type="text" placeholder="????????? ??????" id="keyword">
        <button type="button" class="btn btn-success" id="searchBtn">??????</button>
    </form>
</div>
<c:if test="${ses.email ne '' && ses.email ne null }">
	<form>
	  <div class="input-group mb-3">
	    <div class="input-group-prepend">
	      <span class="input-group-text" id="cmtWriter">${ses.email }</span>
	    </div>
	    <input type="text" class="form-control" id="cmtInput"
	    placeholder="?????? ?????????">
	    <div class="input-group-append">
    	  <button class="btn btn-success" type="button" id="cmtSubmit">ADD</button>
 		</div>
	  </div>
	</form>
</c:if>
<div id="accordion" style="clear: both;">

</div>
<!-- ????????? ?????? The Modal -->
  <div class="modal fade" id="modModal">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title"></h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <!-- Modal body -->
        <div class="modal-body">
           <textarea class="form-control" rows="5" id="cmtText"></textarea>
        </div>
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-warning" >??????</button>
        </div>        
      </div>
    </div>
  </div>
<!-- Modal End -->

<script>
	function modify_comment(cmtObj) {
		let pno_val = $("#pnoVal").text();
		$.ajax({
			url: "/comment/" + cmtObj.cno,
			type: "put",
			data: JSON.stringify(cmtObj),
			contentType: "application/json; charset=utf-8"
		}).done(function() {
			alert("?????? ?????? ??????!!");
			list_comment(pno_val); // list renewal
		}).fail(function(err) {
			alert("?????? ?????? ??????..");
		}).always(function() { // ??????
	        $(document).find("button.close").click();
	    });
	}
	
	function remove_comment(cno){
		let pno_val = $("#pnoVal").text();
		$.ajax({
			url: "/comment/" + cno,
			type: "delete"
		}).done(function(result) {
			alert("?????? ?????? ??????!!"); // list renewal
			list_comment(pno_val);
		}).fail(function(err) {
			alert("?????? ?????? ??????..");
			 console.log(err);
		});
	}
	
	function print_list(clist) {
		if(clist.length == 0) {
			alert("Comment List is empty");
			return;
		} else {
			let listZone = $("#accordion");
			listZone.empty();
			let ses_email = '<c:out value="${ses.email}"/>';
			for (let cvo of clist) { // clist => ??????, ????????????????????? forEach ?????? forOf ??????
				let card = '<div class="card">';
				card += '<div class="card-header">';
				card += '<a class="collapsed card-link" data-toggle="collapse" href="#cmt'+ cvo.cno +'">';
			    card += '<span class="cmt_regdate">'+ cvo.regdate +'</span><span>'+ cvo.writer +'</span></a>';
			    if(cvo.writer == ses_email) {
			    	// ????????? ?????? ??????
			    	card += ' <i class="fa fa-wrench" data-toggle="modal" data-target="#modModal"';
	                card += ' style="color:orange" data-cno="' + cvo.cno + '"></i>';
	                // ????????? ?????? ???
	                card += ' <i class="fa fa-remove" style="color:red" data-cno="' + cvo.cno + '"></i>';

			    }
			    card += '</div><div id="cmt'+ cvo.cno +'" class="collapse" data-parent="#accordion">'; 
			  	card += '<div class="card-body">'+ cvo.content +'</div></div></div>';
				listZone.append(card);
			}
			$(".cmt_regdate").css("margin-right", "30px");
		}
	}
	function list_comment(pno, r="", kw="") { // getJSON = GET ???????????? json data??? ???????????? ajax
		let url_val = (r==""||kw=="") ? "/comment/pno/" + pno + ".json"
				: "/comment/pno/" + pno + "/" + r + "/" + kw + ".json";
		$.getJSON(url_val, function(result) { // server?????? ?????? result ?????????
			console.log(result);
			print_list(result); // ????????? ?????? ?????? ??????
		}).fail(function(err) {
			console.log(err);
			alert("?????? ????????? ?????? ??????!");
		});
	}
	function write_comment() {
		let pno_val = $("#pnoVal").text(); // pno
		let writer_val = $("#cmtWriter").text(); // writer
		let content_val = $("#cmtInput").val(); // content
		if(content_val == null || content_val == '') {
			alert("?????? ????????? ???????????????!");
			return false;
		} else {
			// ????????? ????????? ?????? -> json data??? ????????? ??????!!
			let cmt_data ={
				pno: pno_val,
				writer: writer_val,
				content: content_val
			};
			$.ajax({
				url: "/comment/register",
				type: "post",
				data: JSON.stringify(cmt_data),
				contentType: "application/json; charset=utf-8" // ?????? ?????? json?????? ??????!
			}).done(function(result) {
				alert("?????? ?????? ??????~~");
				list_comment(pno_val); // list ??????????????? pno ??????~
			}).fail(function(err) {
				alert("?????? ?????? ??????..");
			}).always(function() {
				$("#cmtInput").val("");
			});
		}
	}
</script>
<script>
	$(document).on("click", "#searchBtn", function() {
		let range_val = $("#range option:selected").val();
		let kw_val = $("#keyword").val();
		let pno_val = $("#pnoVal").text();
		list_comment(pno_val, range_val, kw_val)
	});
	$(document).on("click", "#cmtSubmit", write_comment); // ????????? ?????? ????????? ????????? ??? () ?????? ?????? => call back
	$(document).on("click", ".fa-remove", function() { // cno ????????????~
		let cno_val = $(this).data("cno"); // data-cno ??????
		remove_comment(cno_val);
	});
	// ????????? ?????? ??????
	$(document).on("click", ".fa-wrench", function() {      
	    let cno_val = $(this).data("cno");
	    let content_val = $(this).closest(".card").find(".card-body").text();      
	    $(document).find(".modal-title").text(cno_val + "??? ?????? ??????");
	    $(document).find("#cmtText").val(content_val);
	 });
	 $(document).on("click", ".modal-footer > button", function() {
	    let cmt_content_val = $(document).find("#cmtText").val();
	    let temp_text = $(document).find(".modal-title").text();
	    let cno_val = $.trim(temp_text.substr(0, temp_text.indexOf("???")));
	    let cmt_obj = {cno: cno_val, content: cmt_content_val};
	    modify_comment(cmt_obj);
	 });
    // ????????? ?????? ???

	$(function() {
		list_comment($("#pnoVal").text());	
	});
</script>
<jsp:include page="../common/footer.jsp" />




