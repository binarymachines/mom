package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@Table(name = "match_record")
@Entity(name = "mildred$MatchRecord")
public class MatchRecord extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -8997408960268275356L;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "doc_id")
    protected Asset doc;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "match_doc_id")
    protected Asset matchDoc;

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

    public void setDoc(Asset doc) {
        this.doc = doc;
    }

    public Asset getDoc() {
        return doc;
    }

    public void setMatchDoc(Asset matchDoc) {
        this.matchDoc = matchDoc;
    }

    public Asset getMatchDoc() {
        return matchDoc;
    }

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


}