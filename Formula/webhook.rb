class Webhook < Formula
  desc "Lightweight, configurable incoming webhook server"
  homepage "https://github.com/adnanh/webhook"
  url "https://github.com/adnanh/webhook/archive/2.8.0.tar.gz"
  sha256 "c521558083f96bcefef16575a6f3f98ac79c0160fd0073be5e76d6645e068398"
  license "MIT"
  head "https://github.com/adnanh/webhook.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hooks.yaml").write <<~EOS
      - id: test
        execute-command: /bin/sh
        command-working-directory: "#{testpath}"
        pass-arguments-to-command:
        - source: string
          name: -c
        - source: string
          name: "pwd > out.txt"
    EOS

    port = free_port
    fork do
      exec bin/"webhook", "-hooks", "hooks.yaml", "-port", port.to_s
    end
    sleep 1

    system "curl", "localhost:#{port}/hooks/test"
    sleep 1
    assert_equal testpath.to_s, (testpath/"out.txt").read.chomp
  end
end
