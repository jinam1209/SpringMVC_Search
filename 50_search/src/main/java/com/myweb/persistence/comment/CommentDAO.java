package com.myweb.persistence.comment;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.myweb.domain.CommentVO;

@Repository
public class CommentDAO implements CommentDAORule {
	private static Logger logger = LoggerFactory.getLogger(CommentDAO.class);
	private final String NS = "CommentMapper.";
	
	@Inject
	private SqlSession sql;

	@Override
	public int insert(CommentVO cvo) {
		return sql.insert(NS + "reg", cvo);
	}

	@Override
	public List<CommentVO> selectList(int pno) {
		return sql.selectList(NS + "list", pno);
	}

	@Override
	public int update(CommentVO cvo) {
		return sql.update(NS + "mod", cvo);
	}

	@Override
	public int delete(int cno) {
		return sql.delete(NS + "del", cno);
	}

	@Override
	public int deleteAll(int pno) {
		return sql.delete(NS + "delAll", pno);
	}

	@Override
	public int selectCount(int pno) {
		return sql.selectOne(NS + "tc", pno);
	}
}
