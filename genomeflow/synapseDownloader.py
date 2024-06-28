import synapseclient

class SynapseDownloader:

    def __init__(self, userId,userPassword):
        self.client = synapseclient.Synapse()
        self.client.login(userId,userPassword)
        self.entity = None

    def accessSample(self,sampleEntity):
        self.entity = self.client.get(sampleEntity,downloadFile=False)

    def downloadSample(self,sampleEntity,downloadLocation="."):
        self.entity = self.client.get(sampleEntity,downloadLocation=downloadLocation)
        print(self.entity.name)
        print(self.entity.path)


