<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/nav.jsp" />

<h2>Product Modify</h2>
<c:choose>
	<c:when test="${ses.email eq pvo.writer }">
		<form action="/product/modify" method="post" enctype="multipart/form-data">
		  <input type="hidden" name="pno" value="${pvo.pno }">
		  <div class="form-group">
		    <label for="title">Title:</label>
		    <input type="text" class="form-control" value="${pvo.title }" id="title" name="title">
		  </div>
		  <div class="form-group">
		    <label for="writer">Writer:</label>
		    <input type="text" class="form-control" id="writer" name="writer" value="${pvo.writer }" disabled>
		  </div>
		  <div class="form-group">
		    <label for="price">Price:</label>
		    <input type="text" class="form-control" value="${pvo.price }" id="price" name="price">
		  </div>
		  <div class="form-group">
		  	<label for="content">Content:</label>
		 	 <textarea class="form-control" rows="5" id="content" name="content">${pvo.content }</textarea>
		  </div>
		  <div class="form-group">
		    <input type="file" class="form-control" id="files" name="files" multiple style="display: none;">
		    <button type="button" class="btn btn-outline-info btn-block" id="fileTrigger">File Upload</button>
		  </div>
		  <div class="form-group">
		    <ul class="list-group" id="newFileZone"></ul>
		  </div>
		  <!-- File List Part-->
	      <c:if test="${pvo.flist.size() > 0 }">
	      	<table class="table table-hover">
		         <tr>
		            <td>
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
		                     <span class="badge badge-success badge-pill">${fvo.fname }</span>
		                     <i class="fa fa-cut" style="font-size:24px" data-uuid="${fvo.uuid }"></i>
		                     </li>
		                  </c:forEach>
		               </ul>      
		            </td>
		         </tr>
	         </table>
	         <script>
		         function remove_file_li (i_obj) { // modify.jsp 45??? ???
		        	 $(i_obj).closest("li").remove(); // ????????? ?????? ????????? view????????? ???????????????
		         }
	         	$(function() {
	         		$(document).on("click", ".fa-cut", function() {
	         			let uuid_obj = $(this); // uuid?????? data?????????
	         			let uuid_val = uuid_obj.data("uuid");
	         			$.ajax({
	         				url: "/product/del_file",
	         				type: "post",
	         				data: {uuid: uuid_val}
	         			}).done(function(result) {
	         				alert("???????????? ??????~");
	         				console.log(uuid_obj); // this ??? 
	         				remove_file_li(uuid_obj);
	         			}).fail(function(err) {
	         				console.log(err);
	         				alert("???????????? ??????!");
	         			});
	         		});
	         	});
	         </script>
	      </c:if>
		  <button type="submit" class="btn btn-primary float-left">Submit</button>
		  <a href="/product/detail?pno=${pvo.pno }" class="btn btn-success float-right">??????</a>
		</form>
	      <script>
			$(document).on("click", "#fileTrigger", function() {
				$("#files").click();
			});
			let regExp = new RegExp("\.(exe|sh|bat|js|msi|dll)$");
			let maxSize = 1048576; // 1 MB
			function fileValidation(fname, fsize) {
				if(regExp.test(fname)) {
					alert(fname + "(???)??? ???????????? ?????? ?????? ???????????????! ");
					return false;
				}else if(fsize > maxSize) {
					alert("1MB ????????? ????????? ???????????????!");
					return false;
				}else{
					return true; // 62??? ???
				}
			}
			$(document).on("change", "#files", function() {
				$("button[type=submit]").attr("disabled", false);
				let formObj = $("#files"); // ???????????? ????????? ?????????
				let fileObjs = formObj[0].files; // file ????????? ?????????
				let fileZone = $("#newFileZone");
				fileZone.html(""); // fileZone ?????????
				
				for (let fobj of fileObjs) {
				      let li = '<li class="list-group-item d-flex justify-content-between align-items-center">';
				      if(fileValidation(fobj.name, fobj.size)){
				         // ????????????
				         li += fobj.name + '<span class="badge badge-success badge-pill">';
				      }else{
				         // ???????????? ??? ????????? ?????? ????????????
				         li += '<i class="fa fa-times-rectangle" style="font-size:24px;color:red"></i>';
				         li += fobj.name + '<span class="badge badge-danger badge-pill">';
				         $("button[type=submit]").attr("disabled", true);
				      }
				      li += (fobj.size/1024).toFixed(2) +' KB</span></li>';
				      fileZone.append(li);
				   }
				});
			</script>
	</c:when>
	<c:otherwise>
		<script>
			alert("???????????? ????????? ??????????????????!");
			location.replace("/member/login"); // login page??? ??????
		</script>
	</c:otherwise>
</c:choose>

<jsp:include page="../common/footer.jsp" />