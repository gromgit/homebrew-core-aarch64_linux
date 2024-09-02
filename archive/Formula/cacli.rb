class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/cloud-annotations/archive/v1.3.2.tar.gz"
  sha256 "e7d8fd54f16098a6ac9a612b021beea3218d9747672d49eff20a285cdee69101"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cacli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3b23e5655ae6dab6b41406e69e8752bf54fac3b95564f13484a34aaa8dfa90fe"
  end

  deprecate! date: "2022-03-16", because: :unsupported

  depends_on "go@1.17" => :build

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
