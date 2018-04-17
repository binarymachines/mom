package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.angrysurfer.mildred.entity.media.key.MatchRecordCompKey;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "match_record")
@Entity(name = "mildred$MatchRecord")
public class MatchRecord extends BaseGenericIdEntity<MatchRecordCompKey> {
    private static final long serialVersionUID = 6482369696115717356L;

    @Column(name = "matcher_name", nullable = false, length = 128)
    protected String matcherName;

    @Column(name = "is_ext_match", nullable = false)
    protected Boolean isExtMatch = false;

    @Column(name = "score")
    protected Double score;

    @Column(name = "max_score")
    protected Double maxScore;

    @Column(name = "min_score")
    protected Double minScore;

    @Column(name = "comparison_result", nullable = false, length = 1)
    protected String comparisonResult;

    @Column(name = "file_parent", length = 256)
    protected String fileParent;

    @Column(name = "file_name", length = 256)
    protected String fileName;

    @Column(name = "match_parent", length = 256)
    protected String matchParent;

    @Column(name = "match_file_name", length = 256)
    protected String matchFileName;

    @EmbeddedId
    protected MatchRecordCompKey id;

    public void setMatcherName(String matcherName) {
        this.matcherName = matcherName;
    }

    public String getMatcherName() {
        return matcherName;
    }

    public void setIsExtMatch(Boolean isExtMatch) {
        this.isExtMatch = isExtMatch;
    }

    public Boolean getIsExtMatch() {
        return isExtMatch;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public Double getScore() {
        return score;
    }

    public void setMaxScore(Double maxScore) {
        this.maxScore = maxScore;
    }

    public Double getMaxScore() {
        return maxScore;
    }

    public void setMinScore(Double minScore) {
        this.minScore = minScore;
    }

    public Double getMinScore() {
        return minScore;
    }

    public void setComparisonResult(String comparisonResult) {
        this.comparisonResult = comparisonResult;
    }

    public String getComparisonResult() {
        return comparisonResult;
    }

    public void setFileParent(String fileParent) {
        this.fileParent = fileParent;
    }

    public String getFileParent() {
        return fileParent;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setMatchParent(String matchParent) {
        this.matchParent = matchParent;
    }

    public String getMatchParent() {
        return matchParent;
    }

    public void setMatchFileName(String matchFileName) {
        this.matchFileName = matchFileName;
    }

    public String getMatchFileName() {
        return matchFileName;
    }

    @Override
    public MatchRecordCompKey getId() {
        return id;
    }

    @Override
    public void setId(MatchRecordCompKey id) {
        this.id = id;
    }


}