class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      :tag      => "v0.21.2",
      :revision => "977791627860a0febb3c217a5322702da109ecbb"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    # k9s consumes the Kubernetes configuration which per default is located at ~/.kube/config
    # Its location can also be set with the KUBECONFIG environment variable
    # Setting it to a non-existing location makes sure the test always fails as expected
    ENV["KUBECONFIG"] = "testpath"
    assert_equal "\e[31mBoom!! \e[0m\e[37mInvalid kubeconfig context detected.\e[0m",
                  shell_output("#{bin}/k9s").split("\n").pop
  end
end
