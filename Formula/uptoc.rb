class Uptoc < Formula
  desc "Convenient static file deployment tool that supports multiple platforms"
  homepage "https://github.com/saltbo/uptoc"
  url "https://github.com/saltbo/uptoc.git",
      tag:      "v1.4.3",
      revision: "30266b490379c816fc08ca3670fd96808214b24c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/uptoc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fdb55595c56c3cf33f60a5c46cff05c8a23153568a99c8734c433ee7e262a4a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X main.release=#{version} -X main.commit=#{Utils.git_head} -X main.repo=#{stable.url}",
      *std_go_args,
      "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uptoc -v 2>&1")
    assert_match "uptoc config", shell_output("#{bin}/uptoc ./abc 2>&1", 1)
  end
end
