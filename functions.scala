class Helper {
    def onlyDate(datetime: String): String = datetime.split("T")(0)

    def getNameFromZenodoGithubDeposit(zenodoName: String): String = zenodoName.split("/")(1).split(":")(0)

    def getLocalPartGithubRepo(url: String): String = url.replace("https://github.com/", "")

    def concatenateMavenGroupAndArtifactIds(groupdId: String, artifactId: String): String = groupdId + ":" + artifactId

    def removeParametersGithubAPI(url: String): String = url.split("\\{")(0)

    def licenseToURL(license: String): String = {
        if(license.contains("mit")) "https://opensource.org/license/MIT"
        else "" // to be completed with more licenses per use case
    }
}