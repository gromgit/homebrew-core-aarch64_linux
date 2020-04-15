class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/training/archive/v1.3.1.tar.gz"
  sha256 "fae8c52e5d2824846641f5bd25697d48e9701d35127a2032d230fd3415b1006b"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb3ed4080f932a028dad2ee995d563b224aba8050ce996d081a941fe22277b23" => :catalina
    sha256 "45221a4f754e577cb36ef5cf4da0f70c84d90020932e72478ffadcd75dc875eb" => :mojave
    sha256 "931fed5c23af443c9dbc8cce44d31e46d6626201a2a8aaa323addfa5a5e461ae" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cacli" do
      project = "github.com/cloud-annotations/training/cacli"
      system "go", "build",
             "-ldflags", "-s -w -X #{project}/version.Version=#{version}",
             "-o", bin/"cacli"
    end
  end

  test do
    # Attempt to list training runs without credentials and confirm that it
    # fails as expected.
    output = shell_output("#{bin}/cacli list 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output.
    assert_match "FAILED\nNot logged in. Use 'cacli login' to log in.", cleaned
  end
end
