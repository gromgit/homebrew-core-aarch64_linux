class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.17.2.tar.gz"
  sha256 "97a6481e1afa1f942be26637a11185d85b3beb834955b642d1769f1777ff39a6"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9c2ce957d07c514c00dabb0e0b0644b5fafc765e6c76bfa1a4b9a4253bb54f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58198534d1572d7071e7be7a8800777081280bf6a14bda52a6b4396071f06bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9325f5c11920d30905b4b821f5469ccb288b6d2a4f5d59151b139413c6f087"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d838fd49be700ef4a176890208f0530e8872302fc3d4203cc3c813ad2cb625f"
    sha256 cellar: :any_skip_relocation, catalina:       "a6bf5f6847df1dcb2fbabcd3e183f31ede25a5942c10eb00ab7c9c504fae9717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f52ae97647ed4fa8216e27cc8ac10fe4cfa60db5a05d5b7e94927d56806c0507"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
