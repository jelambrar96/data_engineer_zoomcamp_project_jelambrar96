import argparse
import logging

from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T


# spark = SparkSession.builder.appName('pySparkSetup').getOrCreate()
spark = SparkSession.builder.master("yarn").appName('GCSFilesRead').getOrCreate()


allowed_events = [
    'CommitCommentEvent',
    'CreateEvent',
    'DeleteEvent',
    'ForkEvent',
    'IssueCommentEvent',
    'IssuesEvent',
    'MemberEvent',
    'PublicEvent',
    'PullRequestEvent',
    'PullRequestReviewCommentEvent',
    'PullRequestReviewEvent',
    'PushEvent',
    'ReleaseEvent',
    'WatchEvent'
]

allowed_issue_state = [
    "open",
    "closed"
]

allowed_user_type = [
    "Bot",
    "Mannequin",
    "Organization",
    "User"
]

allowed_author_association = [
    'COLLABORATOR',
    'CONTRIBUTOR',
    'MANNEQUIN',
    'MEMBER',
    'NONE',
    'OWNER'
]

allowed_action_type = [
    'closed',
    'created',
    'opened',
    'reopened',
    'edited',
    'added'
]

allowed_pull_requests_state = [
    'approved',
    'changes_requested',
    'commented',
    'dismissed'
]

allowed_ref_type = [
    'branch',
    'tag',
    'repository'
]

allowed_pusher_type = [
    'deploy_key',
    'user'
]

allowed_visibility_type = [
    'public',
    'private'
]

allowed_side_type = [
    'LEFT',
    'RIGHT'
]

allowed_active_lock_reason_type = [
    'off-topic',
    'resolved',
    'spam',
    'too heated'
]

allowed_mergeable_state_type = [
    'clean',
    'dirty',
    'unknown',
    'unstable',
    'draft'
]


def create_spark_date_time_columns(df, column_based):
    df = df.withColumn("{column_based}_date", F.to_date(F.col(column_based)))
    return df


def read_spark_dataframes(pattern_filepath):
    df = None
    try:
        df = spark.read.json(pattern_filepath)
    except:
        pass
    return df


def save_spark_dataframe(df, write_filepath):
    df.write\
    .partitionBy("created_at_date")\
    .option("header", True)\
    .mode("append")\
    .parquet(write_filepath)

# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_allowed_events_spark(df, date, write_filepath):
    
    main_df = df.select(
            F.col("id").alias("event_id"),
            F.col("type").alias("event_type"),
            F.col("repo.id").alias("repository_id"),
            F.col("repo.name").alias("repository_name"),
            F.col("repo.url").alias("repository_url"),
            F.col("actor.id").alias("actor_id"),
            F.col("actor.login").alias("actor_login"),
            F.col("actor.url").alias("actor_url"),
            F.col("org.id").alias("org_id"),
            F.col("org.login").alias("org_login"),
            F.col("org.url").alias("org_url"),
            # F.col("payload.push_id").alias("push_id"),
            # F.col("payload.distinct_size").alias("number_of_commits"),
            # F.col("payload.pull_request.base.repo.language").alias("language"),
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),
        )
    
    main_df = create_spark_date_time_columns(df=main_df, column_based="created_at")
    save_spark_dataframe(main_df, write_filepath)

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_commit_events_spark(df, date, write_filepath):
    commit_df = df\
        .filter(F.col("type") == "PushEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id"),
            F.col("payload"),
            F.posexplode(F.col("commits")).alias("index", "commit"),
            F.col("created_at"),
        )\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.push_id").alias("push_id"),
            F.col("index").alias("index_commit"),
            F.col("commit.sha").alias("sha"),
            F.col("commit.author.name").alias("author_name"),
            F.col("commit.author.email").alias("author_email"),
            F.col("commit.message").alias("message"),
            F.col("commit.distinct").alias("distinct"),
            F.col("commit.url").alias("url"),
            F.col("ref"),
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at")          
        )
    commit_df = create_spark_date_time_columns(commit_df, "created_at")
    save_spark_dataframe(df=commit_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# 
# -----------------------------------------------------------------------------
def process_data_push_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "PushEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.push_id").alias("push_id"),
            F.col("payload.size").alias("size"),
            F.col("payload.distinct_size").alias("distinct_size"),
            F.col("payload.ref").alias("ref"),
            F.col("payload.head").alias("head"),
            F.col("payload.before").alias("before"),
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_commit_comment_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "CommitCommentEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.comment.id").alias("commit_comment_id"),
            F.col("payload.comment.position").alias("position"),
            F.col("payload.comment.line").alias("line"),
            F.col("payload.comment.path").alias("path"),
            F.col("payload.comment.commit_id").alias("commit_id"),
            F.col("payload.comment.author_association").alias("author_association"),
            F.col("payload.comment.body").alias("body"),
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_release_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "ReleaseEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.release.id").alias("release_id"),
            F.col("payload.release.tag_name").alias("tag_name"),
            F.col("payload.release.target_commitish").alias("target_commitish"),
            F.col("payload.release.name").alias("name"),
            F.col("payload.release.draft").alias("draft"),
            F.col("payload.release.prerelease").alias("prerelease"),
            F.col("payload.release.body").alias("body"),
            F.to_timestamp( F.col("payload.release.created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("release_created_at"),        
            F.to_timestamp( F.col("payload.release.published_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("release_published_at"),        
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    
    main_df = create_spark_date_time_columns(main_df, "created_at")
    main_df = create_spark_date_time_columns(main_df, "release_created_at")
    main_df = create_spark_date_time_columns(main_df, "release_published_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_delete_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "DeleteEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.ref").alias("payload_ref"), 
            F.col("payload.ref_type").alias("ref_type"), 
            F.col("payload.pusher_type").alias("pusher_type"), 
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_member_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "MemberEvent")\
        .filter(F.col("payload.action").isin(allowed_action_type))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.member.id").alias("member_id"), 
            F.col("payload.member.login").alias("login"), 
            F.col("payload.member.type").alias("type"), 
            F.col("payload.member.site_admin").alias("site_admin"), 
            F.col("payload.action").alias("action"), 
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_fork_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "ForkEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.forkee.name").alias("name"), 
            F.col("payload.forkee.private").alias("private"), 
            F.col("payload.forkee.owner.id").alias("owner_id"), 
            F.col("payload.forkee.owner_login").alias("owner_login"), 
            F.col("payload.forkee.owner_type").alias("owner_type"), 
            F.col("payload.forkee.owner.site_admin").alias("owner_site_admin"), 
            F.col("payload.forkee.description").alias("description"), 
            F.col("payload.forkee.fork").alias("fork"), 
            F.col("payload.forkee.homepage").alias("homepage"), 
            F.col("payload.forkee.size").alias("size"), 
            F.col("payload.forkee.stargazers_count").alias("stargazers_count"), 
            F.col("payload.forkee.watchers_count").alias("watchers_count"), 
            F.col("payload.forkee.language").alias("language"), 
            F.col("payload.forkee.has_issues").alias("has_issues"), 
            F.col("payload.forkee.has_projects").alias("has_projects"), 
            F.col("payload.forkee.has_downloads").alias("has_downloads"), 
            F.col("payload.forkee.has_wiki").alias("has_wiki"), 
            F.col("payload.forkee.has_pages").alias("has_pages"), 
            F.col("payload.forkee.forks_count").alias("forks_count"), 
            F.col("payload.forkee.archived").alias("archived"), 
            F.col("payload.forkee.disabled").alias("disabled"), 
            F.col("payload.forkee.open_issues_count").alias("open_issues_count"), 
            F.col("payload.forkee.allow_forking").alias("allow_forking"), 
            F.col("payload.forkee.is_template").alias("is_template"), 
            F.col("payload.forkee.web_commit_signoff_required").alias("web_commit_signoff_required"), 
            F.col("payload.forkee.topics").alias("topics"), 
            F.col("payload.forkee.visibility").alias("visibility"), 
            F.col("payload.forkee.forks").alias("forks"), 
            F.col("payload.forkee.open_issues").alias("open_issues"), 
            F.col("payload.forkee.watchers").alias("watchers"), 
            F.col("payload.forkee.default_branch").alias("default_branch"), 
            F.col("payload.forkee.public").alias("public"), 
            F.col("payload.forkee.license.key").alias("license_key"), 
            F.col("payload.forkee.license.name").alias("license_name"), 
            F.col("payload.forkee.license.spdx_id").alias("license_spdx_id"), 
            F.to_timestamp( F.col("payload.forkee.created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("fork_created_at"),        
            F.to_timestamp( F.col("payload.forkee.updated_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("fork_updated_at"),        
            F.to_timestamp( F.col("payload.forkee.pushed_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("fork_pushed_at"),        
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_create_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "CreateEvent")\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.ref_type").alias("ref_type"), 
            F.col("payload.master_branch").alias("master_branch"), 
            F.col("payload.description").alias("description"), 
            F.col("payload.pusher_type").alias("pusher_type"), 
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------

def process_data_issue_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "IssuesEvent")\
        .filter(F.col("payload.issue.state").isin(allowed_issue_state))\
        .filter(F.col("payload.issue.user.type").isin(allowed_user_type))\
        .filter(F.col("payload.action").isin(allowed_action_type))\
        .filter(F.col("payload.issue.author_association").isin(allowed_author_association))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.issue.id").alias("issue_id"), 
            F.col("payload.action").alias("action"), 
            F.col("payload.issue.assignee.id").alias("assignee_id"), 
            F.col("payload.issue.milestone.id").alias("milestone_id"), 
            F.col("payload.issue.performed_via_github_app.slug").alias("performed_via_github_app"), 
            F.col("payload.issue.number").alias("number"), 
            F.col("payload.issue.title").alias("title"), 
            F.col("payload.issue.user.login").alias("user_login"), 
            F.col("payload.issue.user.id").alias("user_id"), 
            F.col("payload.issue.user.type").alias("user_type"), 
            F.col("payload.issue.user.site_admin").alias("user_site_admin"), 
            F.col("payload.issue.state").alias("state"), 
            F.col("payload.issue.locked").alias("locked"), 
            F.col("payload.issue.comments").alias(""), 
            F.col("payload.issue.author_association").alias("author_association"), 
            F.col("payload.issue.active_lock_reason").alias("active_lock_reason"), 
            F.col("payload.issue.draft").alias("draft"), 
            F.col("payload.issue.pull_request").alias("pull_request"), 
            F.col("payload.issue.body").alias("body"), 
            F.col("labels").alias("labels"), 
            F.to_timestamp( F.col("payload.issue.created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("issue_created_at"),        
            F.to_timestamp( F.col("payload.issue.updated_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("issue_updated_at"),        
            F.to_timestamp( F.col("payload.issue.closed_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("issue_closed_at"),        
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    
    main_df = create_spark_date_time_columns(main_df, "issue_created_at")
    main_df = create_spark_date_time_columns(main_df, "issue_updated_at")
    main_df = create_spark_date_time_columns(main_df, "issue_closed_at")

    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_issue_comment_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "IssuesCommentEvent")\
        .filter(F.col("user_type").isin(allowed_user_type))\
        .filter(F.col("payload.comment.author_association").isin(allowed_author_association))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.comment.id").alias("comment_id"), 
            F.col("payload.issue.id").alias("issue_id"), 
            F.col("payload.comment.performed_via_github_app.slug").alias("performed_via_github_app"), 
            F.col("payload.user.type").alias("user_type"), 
            F.col("payload.user.site_admin").alias("user_site_admin"), 
            F.col("payload.comment.body").alias("body"), 
            F.col("payload.comment.author_association").alias("author_association"), 
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)



# -----------------------------------------------------------------------------



# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_pull_requests_events_spark(df, date, write_filepath):

    """
        assignees = [a.id for a in pr.assignees] if pr.assignees else None
        requested_reviewers = [r.id for r in pr.requested_reviewers] if pr.requested_reviewers else None
        requested_teams = [t.name for t in pr.requested_teams] if pr.requested_teams else None
        milestone = pr.milestone.id if pr.milestone else None
        labels = [l.name for l in pr.labels] if pr.labels else None
    """
    main_df = df\
        .filter(F.col("type") == "PullRequestEvent")\
        .filter(F.col("payload.pull_request.user.type").isin(allowed_user_type))\
        .filter(F.col("payload.pull_request.state").isin(allowed_pull_requests_state))\
        .filter(F.col("payload.action").isin(allowed_action_type))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.action").alias("action"),
            F.col("payload.pull_request.id").alias("pull_request_id"), 
            F.col("payload.pull_request.assignee.id").alias("assignee_id"), 
            F.col("payload.pull_request.milestone.id").alias("milestone_id"), 
            F.col("payload.pull_request.head.repo.id").alias("head_repo_id"), 
            F.col("payload.pull_request.base.repo.id").alias("base_repo_id"), 
            F.col("payload.pull_request.base.repo.language").alias("language"), 
            F.col("payload.pull_request.number").alias("number"), 
            F.col("payload.pull_request.state").alias("state"), 
            F.col("payload.pull_request.locked").alias("locked"), 
            F.col("payload.pull_request.title").alias("title"), 
            F.col("payload.pull_request.user.login").alias("user_login"), 
            F.col("payload.pull_request.user.id").alias("user_id"), 
            F.col("payload.pull_request.user.type").alias("user_type"), 
            F.col("payload.pull_request.user.site_admin").alias("user_site_admin"), 
            F.col("payload.pull_request.body").alias("body"), 
            F.col("payload.pull_request.merge_commit_sha").alias("merge_commit_sha"), 
            F.col("payload.pull_request.draft").alias("draft"), 
            F.col("payload.pull_request.author_association").alias("author_association"), 
            F.col("payload.pull_request.active_lock_reason").alias("active_lock_reason"), 
            F.col("payload.pull_request.merged").alias("merged"), 
            F.col("payload.pull_request.mergeable").alias("mergeable"), 
            F.col("payload.pull_request.mergeable_state").alias("mergeable_state"), 
            F.col("payload.pull_request.merged_by.id").alias("merged_by"), 
            F.col("payload.pull_request.comments").alias("comments"), 
            F.col("payload.pull_request.review_comments").alias("review_comments"), 
            F.col("payload.pull_request.maintainer_can_modify").alias("maintainer_can_modify"), 
            F.col("payload.pull_request.commits").alias("commits"), 
            F.col("payload.pull_request.additions").alias("additions"), 
            F.col("payload.pull_request.deletions").alias("deletions"), 
            F.col("payload.pull_request.changed_files").alias("changed_files"), 
            F.col("payload.pull_request.head.sha").alias("head_sha"), 
            F.col("payload.pull_request.base.sha").alias("base_sha"), 

            F.to_timestamp( F.col("payload.pull_request.created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("pull_request_created_at"),        
            F.to_timestamp( F.col("payload.pull_request.updated_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("pull_request_updated_at"),        
            F.to_timestamp( F.col("payload.pull_request.closed_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("pull_request_closed_at"),        
            F.to_timestamp( F.col("payload.pull_request.merged_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("pull_request_merged_at"),        

            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )

    main_df = create_spark_date_time_columns(main_df, "pull_request_created_at")
    main_df = create_spark_date_time_columns(main_df, "pull_request_updated_at")
    main_df = create_spark_date_time_columns(main_df, "pull_request_closed_at")
    main_df = create_spark_date_time_columns(main_df, "pull_request_merged_at")

    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_pull_requests_review_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "PullRequestReviewEvent")\
        .filter(F.col("payload.review.user.type").isin(allowed_user_type))\
        .filter(F.col("payload.review.author_association").isin(allowed_author_association))\
        .filter(F.col("payload.action").isin(allowed_action_type))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.action").alias("action"),
            F.col("payload.review.user.id").alias("user_id"),
            F.col("payload.review.user.login").alias("user_login"),
            F.col("payload.review.user.type").alias("user_type"),
            F.col("payload.review.user.site_admin").alias("user_site_admin"),
            F.col("payload.review.body").alias("body"),
            F.col("payload.review.commit_id").alias("commit_id"),
            F.col("payload.review.state").alias("state"),
            F.col("payload.review.author_association").alias("author_association"),
            F.col("payload.payload.pull_request.id").alias("pull_request_id"),
            F.to_timestamp( F.col("payload.review.submitted_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("review_submitted_at"),        
            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    
    main_df = create_spark_date_time_columns(main_df, "review_submitted_at")
    main_df = create_spark_date_time_columns(main_df, "created_at")
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------



# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def process_data_pull_requests_comment_events_spark(df, date, write_filepath):
    main_df = df\
        .filter(F.col("type") == "PullRequestReviewCommentEvent")\
        .filter(F.col("payload.comment.user.type").isin(allowed_user_type))\
        .filter(F.col("payload.comment.author_association").isin(allowed_author_association))\
        .withColumn("id", F.col("id").cast(T.IntegerType()))\
        .drop("type")\
        .select(
            F.col("id").alias("event_id"),
            F.col("payload.comment.id").alias("comment_id"),
            F.col("payload.comment.pull_request_review_id").alias("pull_request_review_id"),
            F.col("payload.comment.diff_hunk").alias("diff_hunk"),
            F.col("payload.comment.path").alias("path"),
            F.col("payload.comment.position").alias("position"),
            F.col("payload.comment.original_position").alias("original_position"),
            F.col("payload.comment.commit_id").alias("commit_id"),
            F.col("payload.comment.original_commit_id").alias("original_commit_id"),
            F.col("payload.comment.user.id").alias("user_id"),
            F.col("payload.comment.user.login").alias("user_login"),
            F.col("payload.comment.user.type").alias("user_type"),
            F.col("payload.comment.user.site_admin").alias("site_admin"),
            F.col("payload.comment.body").alias("body"),
            F.col("payload.comment.author_association").alias("author_association"),
            F.col("payload.comment.start_line").alias("start_line"),
            F.col("payload.comment.original_start_line").alias("original_start_line"),
            F.col("payload.comment.start_side").alias("start_side"),
            F.col("payload.comment.line").alias("line"),
            F.col("payload.comment.original_line").alias("original_line"),
            F.col("payload.comment.side").alias("side"),
            F.col("payload.comment.in_reply_to_id").alias("in_reply_to_id"),
            F.col("payload.pull_request.id").alias("pull_request_id"),
            F.to_timestamp( F.col("payload.comment.created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("comment_created_at"),        
            F.to_timestamp( F.col("payload.comment.updated_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("comment_updated_at"),        

            F.to_timestamp( F.col("created_at"), "yyyy-MM-dd'T'HH:mm:ss'Z'" ).alias("created_at"),        
        )
    main_df = create_spark_date_time_columns(main_df, "comment_created_at")
    main_df = create_spark_date_time_columns(main_df, "comment_updated_at")
    main_df = create_spark_date_time_columns(main_df, "created_at")
    
    save_spark_dataframe(df=main_df, write_filepath=write_filepath)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
def main(date, read_filepath, destination_bucket):

    logging.info("Inside main function")
    logging.info("arguments:")
    logging.info(date)
    logging.info(read_filepath)
    logging.info(destination_bucket)

    logging.info("Creating read filepath")
    read_filepath_str = read_filepath.format(date)
    logging.info(read_filepath_str)

    date_str = date.replace("-", "")

    logging.info("reading files")
    # df = spark.read.json(read_filepath_str)
    df = read_spark_dataframes(pattern_filepath=read_filepath_str)

    assert df.count() > 0, "ERROR: df.count() > 0"
    assert len(df.columns) > 0, "ERROR: len(df.columns) > 0"

    # common processing for all tables
    logging.info("filtering file")
    df = df.filter(F.col("type").isin(allowed_events))
    # df = df.withColumn("id", F.col("id").cast(T.IntegerType()))

    # -----------------------------------------------------------------------------
    # ALLOWED EVENTS
    # -----------------------------------------------------------------------------
    
    write_filepath = f"gs://{destination_bucket}/gh-archives/processed/allowed_events/"
    process_data_allowed_events_spark(df=df, date=date_str, write_filepath=write_filepath)

    # -----------------------------------------------------------------------------

    return

    write_filepath_commits_events = f"gs://{destination_bucket}/gh-archives/processed/commits_events"
    process_data_commit_events_spark(df=df, date=date_str, write_filepath=write_filepath_commits_events)

    write_filepath_push_events = f"gs://{destination_bucket}/gh-archives/processed/push_events"
    process_data_push_events_spark(df=df, date=date_str, write_filepath=write_filepath_push_events)

    write_file_path_release = f"gs://{destination_bucket}/gh-archives/processed/release_events"
    process_data_release_events_spark(df=df, date=date_str, write_filepath=write_file_path_release)

    write_file_path_delete = f"gs://{destination_bucket}/gh-archives/processed/delete_events"
    process_data_delete_events_spark(df=df, date=date_str, write_filepath=write_file_path_delete)

    write_file_path_member = f"gs://{destination_bucket}/gh-archives/processed/member_events"
    process_data_member_events_spark(df=df, date=date_str, write_filepath=write_file_path_member)

    write_file_fork_events = f"gs://{destination_bucket}/gh-archives/processed/fork_events"
    process_data_fork_events_spark(df=df, date=date_str, write_filepath=write_file_fork_events)

    write_file_create_events = f"gs://{destination_bucket}/gh-archives/processed/create_events"
    process_data_create_events_spark(df=df, date=date_str, write_filepath=write_file_create_events)

    write_file_pull_issue_events = f"gs://{destination_bucket}/gh-archives/processed/issue_event"
    process_data_issue_events_spark(df=df, date=date_str, write_filepath=write_file_pull_issue_events)

    write_file_pull_issue_comment_events = f"gs://{destination_bucket}/gh-archives/processed/issue_comment_event"
    process_data_issue_comment_events_spark(df=df, date=date_str, write_filepath=write_file_pull_issue_comment_events)

    write_file_pull_requests_events = f"gs://{destination_bucket}/gh-archives/processed/pull_requests_events"
    process_data_pull_requests_events_spark(df=df, date=date_str, write_filepath=write_file_pull_requests_events)

    write_file_pull_requests_review = f"gs://{destination_bucket}/gh-archives/processed/pull_requests_review_events"
    process_data_pull_requests_review_events_spark(df=df, date=date_str, write_filepath=write_file_pull_requests_review)

    write_file_pull_requests_comment_events = f"gs://{destination_bucket}/gh-archives/processed/pull_requests_comment_events"
    process_data_pull_requests_comment_events_spark(df=df, date=date_str, write_filepath=write_file_pull_requests_comment_events)

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--date", help="Date in format YYYY-MM-DD", required=True)
    parser.add_argument("--source", help="Source files pattern for the GH archive to process.", required=True)
    parser.add_argument("--destination", help="Destination bucket.", required=True)

    args = parser.parse_args()
    date = args.date
    read_filepath = args.source
    destination_bucket = args.destination
    main(date, read_filepath, destination_bucket)

# -----------------------------------------------------------------------------
