package com.myweb.service.comment;

import java.util.List;

import com.myweb.domain.CommentVO;

public interface CommentServiceRule {
	public int register(CommentVO cvo);
	public List<CommentVO> getList(int pno);
	public int modify(CommentVO cvo);
	public int remove(int cno);
	public int removeAll(int pno);
	public int getTotalCount(int pno);
}
