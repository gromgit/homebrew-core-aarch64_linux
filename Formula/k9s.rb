class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.7",
      revision: "37569b8772eee3ae29c3a3a1eabb34f459f0b595"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cbae4de112ce5d826b52492de8397ea1fe0e20af9620a73d9a4ed814035b29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3e4571adb2c0269ba9a070957b125857114f1218ea3d431cbb97ecdd5d81bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "f7f51f4dc56beacd42727a3fec55c4dcf1e82868697365dfe14e913ae1272de5"
    sha256 cellar: :any_skip_relocation, big_sur:        "04118d8e20b787dd55d78da8673f8a69944f9bb10df56cc059a3707db7c8997e"
    sha256 cellar: :any_skip_relocation, catalina:       "211fd67c922f29dd60e7e1a5abe9c5f4e9df6f285e61161f87ee8bd7f2b08ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ace55af7f8453972f2891d5ffcbfded2324b5af52a26dfbd4298c6f4915b3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
