class HolosTdaCheck < Formula
  desc "Independent checker for Holos proof and coordinate artifacts"
  homepage "https://github.com/t0rsion/holos"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-check-aarch64-apple-darwin.tar.xz"
      sha256 "3ae202d50a5a5eb24f01c2e8b93d89b6fe89c401323b9d5d113f31b62a6d0849"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-check-x86_64-apple-darwin.tar.xz"
      sha256 "9beb658567de0c27ef5ebb543dd7e16584171bcc1d7b7ea1b81f9ed550490953"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-check-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e18598d47cedd1386822b0824a1f1dec282b15560e0a26ac56b754c00b43fe7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-check-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f945eef88cc3a226068be8b98b60b0bc07208ebefc6cfc69fc23569569daf9b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos-check"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
