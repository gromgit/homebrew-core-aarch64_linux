class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.1",
      revision: "cd3f6fa3231ae8abf7f028eb7163d74aafd6ae94"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0ffd831dc96d374f15a4c196411803a5cbc02eb6bf5c5033e22c4382d495086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1dd6be533729e03fb3cbbc5180f85c1a6e72ff642282f967a4bef18b9f214d"
    sha256 cellar: :any_skip_relocation, monterey:       "a08f9fedc961467ef0b0091545ed2c01521e50c2cea116ee30e5979bdb468c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0bdaf80a89ef9a2e4d8fd1198ebe85780d8edbf29d8461540e99d212265dce8"
    sha256 cellar: :any_skip_relocation, catalina:       "d3dec0e73a68e541fdf0f6f4669e8f42af3a0b3a0160d3f28bcfc7cd99a6a50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ccc4d5f954b694486b85ae852631a573f74fbb87d2fcd39f4822d65e57e345e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
