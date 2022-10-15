class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.3",
      revision: "81e44af02f368afe411e29d095a9ed5494018e66"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 2.2.3. Until then, it's used to omit an older tag that would always
  # be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v2.2.3"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55cab393bdfcf94fea81f0a50cb274990dacf1992acec72a3f1777767dd37256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae52545e4ffe685e2f211aaebc8b34dd0095f99badfe0408b777da1604cc3eda"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c2c7f28fca29be8e196ca3c4117b7dd7720e08202960d4dd0afac8bcc4b32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4825f834520493e21c0535506deb0b4ec4f654c9d15ff83df36ca2f4f930751d"
    sha256 cellar: :any_skip_relocation, catalina:       "b81e665432dceef8d85096619b234d7ba138ff1f6c71ec412c18ef58d0b38931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f8da7c4b41fb874ee715402d8e30fbe390f916b55aa73526f8d6cc386be743"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
