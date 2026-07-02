class Helper {
    def onlyDate(datetime: String): String = datetime.split("T")(0)

    def getNameFromZenodoGithubDeposit(zenodoName: String): String = zenodoName.split("/")(1).split(":")(0)

    def getLocalPartGithubRepo(url: String): String = url.replace("https://github.com/", "")

    def getLocalPartGithubRepoToLowerCase(url: String): String = getLocalPartGithubRepo(url).toLowerCase

    def concatenateMavenGroupAndArtifactIds(groupId: String, artifactId: String): String = groupId + ":" + artifactId

    def removeParametersGithubAPI(url: String): String = url.split("\\{")(0)

    def normalizeGitHubAPIUrl(url: String): String = {
        url.replace("api.", "")
            .replace("/repos", "")
            .replaceAll("\\{.+\\}", "")
    }

    def licenseToURL(license: String): String = {
        if(license.contains("mit")) "https://opensource.org/license/MIT"
        else "" // to be completed with more licenses per use case
    }
}